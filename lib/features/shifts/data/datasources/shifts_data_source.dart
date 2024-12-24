import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';

abstract interface class ShiftDataSource {
  Future<Either<Failure, int>> insertShift(InsertShiftParams params);

  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllShifts(
      NoParams noParams);

  Future<Either<Failure, int>> updateShift(UpdateShiftParams params);

  Future<Either<Failure, int>> deleteShift(int id);
}

class ShiftDataSourceImpl implements ShiftDataSource {
  final SQLFLiteFFIConsumer _databaseConsumer;

  ShiftDataSourceImpl(this._databaseConsumer);

  @override
  Future<Either<Failure, int>> insertShift(InsertShiftParams params) async {
    try {
      final data = {
        'total_collected_money': params.totalCollectedMoney,
        'from_time': params.fromTime.toIso8601String(),
        'to_time': params.toTime.toIso8601String(),
        'user_id': params.userId,
      };

      // Insert data into the 'shifts' table
      return await _databaseConsumer.add('shifts', data);
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to insert shift: $e'));
    }
  }

  @override
  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllShifts(
      NoParams noParams) async {
    try {
      // Perform a JOIN query to fetch shifts and associated usernames
      const query = '''
      SELECT 
        shifts.id AS shift_id, 
        shifts.total_collected_money, 
        shifts.from_time, 
        shifts.to_time, 
        shifts.user_id, 
        users.username AS shift_user_name
      FROM 
        shifts
      LEFT JOIN 
        users 
      ON 
        shifts.user_id = users.id
    ''';

      // Execute the query using the database consumer
      final result = await _databaseConsumer.get(query);

      return result.fold(
          (left) => Left(UnknownFailure(
              message: 'Failed to fetch shifts ${left.message}')),
          (right) => Right(right));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to fetch shifts: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> updateShift(UpdateShiftParams params) async {
    try {
      final data = <String, dynamic>{};

      if (params.totalCollectedMoney != null) {
        data['total_collected_money'] = params.totalCollectedMoney;
      }
      if (params.fromTime != null) {
        data['from_time'] = params.fromTime!.toIso8601String();
      }
      if (params.toTime != null) {
        data['to_time'] = params.toTime!.toIso8601String();
      }
      if (params.userId != null) {
        data['user_id'] = params.userId;
      }

      // Update shift data in the 'shifts' table based on the shift ID
      return await _databaseConsumer.update(
        'shifts',
        data,
        where: 'id = ?',
        whereArgs: [params.id],
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to update shift: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> deleteShift(int id) async {
    try {
      final result = await _databaseConsumer.delete(
        'shifts',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result.fold(
          (l) => Left(
              UnknownFailure(message: 'Failed to delete shift: ${l.message}')),
          (r) => Right(r));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to delete shift: $e'));
    }
  }
}

class InsertShiftParams {
  final double totalCollectedMoney;
  final DateTime fromTime;
  final DateTime toTime;
  final int userId;

  InsertShiftParams({
    required this.totalCollectedMoney,
    required this.fromTime,
    required this.toTime,
    required this.userId,
  });
}

class UpdateShiftParams {
  final int id;
  final double? totalCollectedMoney;
  final DateTime? fromTime;
  final DateTime? toTime;
  final int? userId;

  UpdateShiftParams({
    required this.id,
    this.totalCollectedMoney,
    this.fromTime,
    this.toTime,
    this.userId,
  });
}
