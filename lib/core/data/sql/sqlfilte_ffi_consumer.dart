import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart';
import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

abstract interface class SQLFLiteFFIConsumer {
  Future<Either<Failure, void>> initDatabase(String databaseName);

  Future<Either<Failure, int>> add(String table, Map<String, dynamic> data);

  Future<Either<Failure, List<Map<String, dynamic>>>> get(String table,
      {String? where, List<dynamic>? whereArgs});

  Future<Either<Failure, int>> update(String table, Map<String, dynamic> data,
      {String? where, List<dynamic>? whereArgs});

  Future<Either<Failure, int>> delete(String table,
      {String? where, List<dynamic>? whereArgs});

//for multiple insertion
  Future<Either<Failure, void>> batchInsert(BatchInsertParams params);

  Future<Either<Failure, String>> getDatabasePath(String databaseName);

  Future<Either<Failure, void>> exportToExcelFile(BackupParams params);

  Future<Either<Failure, void>> importToExcel(BackupParams params);

  Future<Either<Failure, void>> clearTable(String tableName);
}

class SQLFLiteFFIConsumerImpl implements SQLFLiteFFIConsumer {
  Database? _database;

  @override
  Future<Either<Failure, void>> initDatabase(String databaseName) async {
    try {
      logger('Initializing database');
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      final dbPath = await getDatabasesPath();
      logger(dbPath);
      final path = join(dbPath, databaseName);

      // Open the database with the version incremented for migrations
      _database = await openDatabase(
        path,
        version:6, // Incremented database version
        onCreate: (db, version) async {
          logger('Creating database schema');

          // Create the 'users' table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            isAdmin BOOLEAN NOT NULL DEFAULT 0
          )
        ''');

          // Create the 'restaurants' table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS restaurants (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            image TEXT,
            price REAL NOT NULL,
            type TEXT NOT NULL CHECK(type IN ('drink', 'dish'))
          )
        ''');

          // Create the 'rooms' table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS rooms (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            device_type TEXT NOT NULL CHECK(device_type IN ('PS4', 'PS5')),
            state TEXT NOT NULL CHECK(state IN ('running', 'not running', 'paused', 'pre-booked')),
            open_time BOOLEAN DEFAULT NULL,
            is_multiplayer BOOLEAN NOT NULL,
            price REAL NOT NULL DEFAULT 0,
            remaining_time TIMESTAMP DEFAULT NULL
          )
        ''');

          // Set default prices for existing rooms
          await db.execute('''
          UPDATE rooms
          SET price = CASE
            WHEN device_type = 'PS4' AND is_multiplayer = 0 THEN 20
            WHEN device_type = 'PS4' AND is_multiplayer = 1 THEN 30
            WHEN device_type = 'PS5' AND is_multiplayer = 0 THEN 30
            WHEN device_type = 'PS5' AND is_multiplayer = 1 THEN 50
            ELSE 0
          END
        ''');

          // Create a trigger to ensure constraints between open_time and remaining_time
          await db.execute('''
  CREATE TRIGGER ensure_open_time_remaining_time_exclusive
  BEFORE UPDATE ON rooms
  FOR EACH ROW
  BEGIN
    -- Ensure that `remaining_time` is NULL when `open_time` is TRUE
    UPDATE rooms SET remaining_time = NULL WHERE NEW.open_time = 1;

    -- Ensure that `open_time` is NULL when `remaining_time` has a value
    UPDATE rooms SET open_time = NULL WHERE NEW.remaining_time IS NOT NULL;
  END;
''');

          // Create the 'shifts' table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS shifts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            total_collected_money REAL NOT NULL,
            from_time TIMESTAMP NOT NULL,
            to_time TIMESTAMP NOT NULL
          )
        ''');

          // Create the 'room_consumptions' table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS room_consumptions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            room_id INTEGER NOT NULL,
            restaurant_id INTEGER NOT NULL,
            quantity INTEGER NOT NULL DEFAULT 1,
            FOREIGN KEY (room_id) REFERENCES rooms (id) ON DELETE CASCADE,
            FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
          )
        ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < 7) {
            logger('Upgrading database to version $newVersion');

            logger('Upgrading database to version $newVersion');

            // Step 1: Create a new table with the updated CHECK constraint
            await db.execute('''
      CREATE TABLE rooms_new (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        device_type TEXT NOT NULL CHECK(device_type IN ('PS4', 'PS5')),
        state TEXT NOT NULL CHECK(state IN ('running', 'not running', 'paused', 'pre-booked')),
        open_time BOOLEAN DEFAULT NULL,
        is_multiplayer BOOLEAN NOT NULL,
        price REAL NOT NULL DEFAULT 0,
        remaining_time TIMESTAMP DEFAULT NULL
      )
    ''');

            // Step 2: Copy the data from the old table to the new table
            await db.execute('''
      INSERT INTO rooms_new (id, device_type, state, open_time, is_multiplayer, price, remaining_time)
      SELECT id, device_type, state, open_time, is_multiplayer, price, remaining_time FROM rooms
    ''');

            // Step 3: Drop the old table
            await db.execute('DROP TABLE rooms');

            // Step 4: Rename the new table to the original table name
            await db.execute('ALTER TABLE rooms_new RENAME TO rooms');

            logger('Database upgraded successfully to version $newVersion');





            // Update the 'price' column based on conditions
            await db.execute('''
            UPDATE rooms
            SET price = CASE
              WHEN device_type = 'PS4' AND is_multiplayer = 0 THEN 20
              WHEN device_type = 'PS4' AND is_multiplayer = 1 THEN 30
              WHEN device_type = 'PS5' AND is_multiplayer = 0 THEN 30
              WHEN device_type = 'PS5' AND is_multiplayer = 1 THEN 50
              ELSE 0
            END
          ''');

            // Re-create the trigger
            await db.execute('''
  CREATE TRIGGER ensure_open_time_remaining_time_exclusive
  BEFORE UPDATE ON rooms
  FOR EACH ROW
  BEGIN
    -- Ensure that `remaining_time` is NULL when `open_time` is TRUE
    UPDATE rooms SET remaining_time = NULL WHERE NEW.open_time = 1;

    -- Ensure that `open_time` is NULL when `remaining_time` has a value
    UPDATE rooms SET open_time = NULL WHERE NEW.remaining_time IS NOT NULL;
  END;
''');
          }
        },
      );

      logger('Database initialized');
      return Right(null); // Success
    } catch (e) {
      loggerError('Database initialization failed: $e');
      return Left(
          UnknownFailure(message: 'Database initialization failed: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> add(
      String table, Map<String, dynamic> data) async {
    try {
      if (_database == null) throw Exception("Database not initialized");
      final id = await _database!.insert(table, data);
      return Right(id);
    } catch (e) {
      return Left(CreateFailure(message: 'Failed to add data: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> get(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    try {
      if (_database == null) throw Exception("Database not initialized");
      final result = await _database!.query(
        table,
        where: where,
        whereArgs: whereArgs,
      );
      return Right(result);
    } catch (e) {
      return Left(AuthFailure('Failed to fetch data: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> update(String table, Map<String, dynamic> data,
      {String? where, List<dynamic>? whereArgs}) async {
    try {
      if (_database == null) throw Exception("Database not initialized");
      final rowsAffected = await _database!.update(
        table,
        data,
        where: where,
        whereArgs: whereArgs,
      );
      return Right(rowsAffected);
    } catch (e) {
      return Left(AuthFailure('Failed to update data: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> delete(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    try {
      if (_database == null) throw Exception("Database not initialized");
      final rowsDeleted = await _database!.delete(
        table,
        where: where,
        whereArgs: whereArgs,
      );
      return Right(rowsDeleted);
    } catch (e) {
      return Left(AuthFailure('Failed to delete data: $e'));
    }
  }

  // Implementation of the export method
  @override
  Future<Either<Failure, void>> exportToExcelFile(BackupParams params) async {
    try {
      if (_database == null) throw Exception("Database not initialized");

      // Fetch data from the table
      final data = await get(params.table);

      return data.fold(
        (failure) {
          // Handling failure case for fetching data
          return Left(UnknownFailure(
              message:
                  'Failed to fetch data for export: ${failure.toString()}'));
        },
        (result) async {
          // Create a new Excel document
          var excel = Excel.createExcel();
          Sheet sheet = excel['Sheet1']; // Create a sheet

          // Assuming the result is a list of maps (for example, each record is a Map)
          if (result.isNotEmpty) {
            Map<String, dynamic> firstRecord = result[0];

            // Write headers to the first row
            List<String> headers = firstRecord.keys.toList();
            sheet.appendRow(headers
                .map((e) => TextCellValue(e))
                .toList()); // Convert headers to CellValue

            // Write the data to subsequent rows
            for (var record in result) {
              sheet.appendRow(record.values
                  .map((e) => TextCellValue(e.toString()))
                  .toList()); // Convert values to CellValue
            }
          }

          try {
            // Write the Excel data to a file
            final file = File(params.filePath);

            // Ensure the file exists (create if not)
            if (!(await file.exists())) {
              await file.create(recursive: true);
            }

            // Save the Excel file
            var excelBytes = excel.encode();
            await file.writeAsBytes(excelBytes!);

            return Right(null); // Success
          } catch (e) {
            return Left(
                UnknownFailure(message: 'Failed to write Excel file: $e'));
          }
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to export data: $e'));
    }
  }

  // Implementation of the import method
  @override
  Future<Either<Failure, void>> importToExcel(BackupParams params) async {
    try {
      if (_database == null) throw Exception("Database not initialized");

      // Read the Excel file
      final file = File(params.filePath);
      if (!await file.exists()) {
        return Left(UnknownFailure(message: 'File not found'));
      }

      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      // Access the first sheet (assume it's always the first one for simplicity)
      final sheetName = excel.tables.keys.first;
      final sheet = excel.tables[sheetName];
      if (sheet == null) {
        return Left(UnknownFailure(message: 'Sheet not found or is empty'));
      }

      // Iterate through rows (skip the header row)
      for (int i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];

        try {
          // Use the provided rowMapper to map the row to a data object
          final data = params.rowMapper!(row);
          if (data.isNotEmpty) {
            // Check if the record already exists by querying the database
            final existingRecords = await get(
              params.table,
              where: 'username = ?',
              whereArgs: [data['username']], // Assuming 'username' is unique
            );
            existingRecords
                .fold((left) => UnknownFailure(message: 'No Existing Records'),
                    (right) async {
              if (right.isEmpty) {
                // Only add the new record if it doesn't exist
                await add(params.table, data);
              }
            });
          }
        } catch (e) {
          return Left(
              UnknownFailure(message: 'Error processing row ${i + 1}: $e'));
        }
      }

      return Right(null); // Success
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to import data: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> getDatabasePath(String databaseName) async {
    try {
      // Get the default path for databases
      final dbPath = await getDatabasesPath();

      // Append the database name to the path
      final fullPath = join(dbPath, databaseName);

      return Right(fullPath);
    } catch (e) {
      loggerError("Error getting database path: $e");
      return Left(UnknownFailure(message: 'Failed to get database path: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> batchInsert(BatchInsertParams params) async {
    try {
      final batch = _database!.batch();

      for (final data in params.dataList) {
        batch.insert(
          params.table,
          data,
          conflictAlgorithm:
              params.conflictAlgorithm ?? ConflictAlgorithm.ignore,
        );
      }

      await batch.commit(noResult: true);
      return Right(null); // Indicate success
    } catch (e) {
      return Left(UnknownFailure(message: 'Batch insert failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearTable(String tableName) async {
    try {
      if (_database == null) {
        return Left(DatabaseNotInitializedFailure('Not Initialized'));
      }

      logger('Clearing table: $tableName');

      // Use a raw SQL command to delete all rows from the specified table
      await _database!.execute('DELETE FROM $tableName');

      logger('Table cleared successfully: $tableName');
      return Right(null); // Success
    } catch (e) {
      loggerError('Failed to clear table $tableName: $e');
      return Left(
          UnknownFailure(message: 'Failed to clear table $tableName: $e'));
    }
  }
}

class BackupParams extends Equatable {
  final String table;
  final String filePath;
  final Map<String, dynamic> Function(List<Data?> row)? rowMapper;

  const BackupParams(
      {required this.table, required this.filePath, this.rowMapper});

  @override
  List<Object?> get props => [table, filePath, rowMapper];
}

class BatchInsertParams extends Equatable {
  final String table;
  final List<Map<String, dynamic>> dataList;
  final ConflictAlgorithm? conflictAlgorithm;

  const BatchInsertParams({
    required this.table,
    required this.dataList,
    this.conflictAlgorithm,
  });

  @override
  List<Object?> get props => [table, dataList, conflictAlgorithm];
}
