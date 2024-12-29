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

  Future<Either<Failure, List<Map<String, dynamic>>>> rawGet(String query,
      {List<dynamic>? whereArgs});

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

  Future<Either<Failure, T>> runTransaction<T>(
      Future<T> Function(Transaction txn) transactionCallback);
}

class SQLFLiteFFIConsumerImpl implements SQLFLiteFFIConsumer {
  Database? _database;

  @override
  Future<Either<Failure, void>> initDatabase(String databaseName) async {
    try {
      // logger('Initializing database');
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      final dbPath = await getDatabasesPath();
      // logger('dbPath: $dbPath');
      final path = join(dbPath, databaseName);

      _database = await openDatabase(
        path,
        version: 23, // Incremented database version
        onCreate: (db, version) async {
          logger('Creating database schema');

          await db.execute('''
          CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL,
            isAdmin BOOLEAN NOT NULL DEFAULT 0  -- False for regular users, True for admins
          )
        ''');
          // Create the 'users' table with the 'isAdmin' column

          // Create the 'restaurants' table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS restaurants (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            image TEXT,
            price REAL NOT NULL,
            type TEXT NOT NULL CHECK(type IN ('drink', 'dish')),
            default_recipe_id INTEGER, -- Optional reference to a primary recipe
            FOREIGN KEY (default_recipe_id) REFERENCES recipes (id) ON DELETE SET NULL
          );
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
            time TEXT NOT NULL DEFAULT '00:00:00',
            multi_time TEXT NOT NULL DEFAULT '00:00:00'
          );
        ''');

          // Create the 'controllers' table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS controllers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            device_type TEXT NOT NULL CHECK(device_type IN ('PS4', 'PS5')),
            state TEXT NOT NULL CHECK(state IN ('running', 'not running')),
            room_id INTEGER NOT NULL,
            FOREIGN KEY (room_id) REFERENCES rooms (id) ON DELETE CASCADE
          );
        ''');

          // Create the 'shifts' table with a foreign key reference to 'users'
          await db.execute('''
          CREATE TABLE IF NOT EXISTS shifts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            total_collected_money REAL NOT NULL,
            from_time TIMESTAMP NOT NULL,
            to_time TIMESTAMP NOT NULL,
            user_id INTEGER,  -- Reference to 'users' table
            FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL
          );
        ''');

          // Create the 'room_consumptions' table with a 'paid' column
          await db.execute('''
          CREATE TABLE IF NOT EXISTS room_consumptions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            room_id INTEGER NOT NULL,
            restaurant_id INTEGER NOT NULL,
            quantity INTEGER NOT NULL DEFAULT 1,
            price REAL NOT NULL DEFAULT 0.0,
            total_price REAL AS (quantity * price) STORED,
            paid BOOLEAN NOT NULL DEFAULT 0,  -- New 'paid' column with default value false
            FOREIGN KEY (room_id) REFERENCES rooms (id) ON DELETE CASCADE,
            FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
          );
        ''');

          // Create the 'recipes' table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS recipes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL, -- Recipe name
            ingredient_name TEXT NOT NULL,
            quantity REAL DEFAULT 0,
            weight REAL DEFAULT 0,
            CHECK (quantity IS NOT NULL OR weight IS NOT NULL)
          );
        ''');

          // Create the 'restaurant_recipes' table to associate recipes with restaurants and quantities
          await db.execute('''
          CREATE TABLE IF NOT EXISTS restaurant_recipes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            restaurant_id INTEGER NOT NULL,
            recipe_id INTEGER NOT NULL,
            quantity REAL NOT NULL, -- Quantity required for the recipe in the restaurant
            FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE,
            FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
          );
        ''');

          // Create the 'reports' table
          await db.execute('''
          CREATE TABLE IF NOT EXISTS reports (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            table_name TEXT NOT NULL,
            data TEXT NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          );
        ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          logger('Upgrading database from version $oldVersion to $newVersion');

          if (oldVersion < 23) {
            // Create the new 'restaurant_recipes' table
            await db.execute('''
            CREATE TABLE IF NOT EXISTS restaurant_recipes (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              restaurant_id INTEGER NOT NULL,
              recipe_id INTEGER NOT NULL,
              quantity REAL NOT NULL,
              FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE,
              FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
            );
          ''');
          }

          logger('Database upgrade to version $newVersion completed');
        },
      );

      // logger('Database initialized');
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
  Future<Either<Failure, List<Map<String, dynamic>>>> rawGet(
    String query, {
    List<dynamic>? whereArgs,
  }) async {
    try {
      if (_database == null) throw Exception("Database not initialized");

      // Use rawQuery to execute the custom SQL query
      final result = await _database!.rawQuery(query, whereArgs ?? []);

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

  @override
  Future<Either<Failure, T>> runTransaction<T>(
      Future<T> Function(Transaction txn) transactionCallback) async {
    try {
      if (_database == null) throw Exception("Database not initialized");
      final result = await _database!.transaction((txn) async {
        return await transactionCallback(txn);
      });
      return Right(result);
    } catch (e) {
      return Left(AuthFailure('Transaction failed: $e'));
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
