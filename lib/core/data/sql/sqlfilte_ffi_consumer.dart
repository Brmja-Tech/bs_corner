import 'dart:convert';
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

  Future<Either<Failure, String>> getDatabasePath(String databaseName);

  Future<Either<Failure, void>> exportToExcelFile(BackupParams params);

  Future<Either<Failure, void>> importToExcel(BackupParams params);
}

class SQLFLiteFFIConsumerImpl implements SQLFLiteFFIConsumer {
  Database? _database;

  @override
  Future<Either<Failure, void>> initDatabase(String databaseName) async {
    try {
      logger('init');
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      final dbPath = await getDatabasesPath();
      final path = join(dbPath, databaseName);

      // Open the database with version 2 (increment the version)
      _database = await openDatabase(
        path,
        version: 2, // Incremented version number
        onCreate: (db, version) async {
          // Initial schema for version 1 (creating the tables)
          await db.execute('''
          CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');

          // Create the 'restaurants' table (for drinks and dishes)
          await db.execute('''
          CREATE TABLE IF NOT EXISTS restaurants (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            image TEXT,  -- URL or file path for image
            price REAL NOT NULL,
            type TEXT NOT NULL CHECK(type IN ('drink', 'dish'))  -- Restrict type to 'drink' or 'dish'
          )
        ''');

          // Create the 'rooms' table (for PS4/PS5 room state management)
          await db.execute('''
          CREATE TABLE IF NOT EXISTS rooms (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            device_type TEXT NOT NULL CHECK(device_type IN ('PS4', 'PS5')),  -- Restrict to PS4 or PS5
            state TEXT NOT NULL CHECK(state IN ('running', 'not running', 'paused')),  -- Valid states
            open_time BOOLEAN NOT NULL,  -- True or False for open/closed
            is_multiplayer BOOLEAN NOT NULL  -- True or False for multiplayer or single-player
          )
        ''');

          // Create the 'shifts' table (for tracking shifts and collected money)
          await db.execute('''
          CREATE TABLE IF NOT EXISTS shifts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            total_collected_money REAL NOT NULL,  -- Total money collected in shift
            from_time TIMESTAMP NOT NULL,  -- Shift start time
            to_time TIMESTAMP NOT NULL  -- Shift end time
          )
        ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          // Handle schema migration when upgrading from version 1 to version 2
          if (oldVersion < 2) {
            // You can add any new tables or modify the schema here for version 2

            // For example, creating new tables if needed:
            await db.execute('''
            CREATE TABLE IF NOT EXISTS restaurants (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL,
              image TEXT,
              price REAL NOT NULL,
              type TEXT NOT NULL CHECK(type IN ('drink', 'dish'))
            )
          ''');

            await db.execute('''
            CREATE TABLE IF NOT EXISTS rooms (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              device_type TEXT NOT NULL CHECK(device_type IN ('PS4', 'PS5')),
              state TEXT NOT NULL CHECK(state IN ('running', 'not running', 'paused')),
              open_time BOOLEAN NOT NULL,
              is_multiplayer BOOLEAN NOT NULL
            )
          ''');

            await db.execute('''
            CREATE TABLE IF NOT EXISTS shifts (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              total_collected_money REAL NOT NULL,
              from_time TIMESTAMP NOT NULL,
              to_time TIMESTAMP NOT NULL
            )
          ''');
          }
        },
      );

      loggerWarn('initialized');
      return Right(null); // Success
    } catch (e) {
      loggerError(e);
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
