import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/features/shifts/data/models/shift_model.dart';

abstract interface class ShiftDataSource {
  Future<Either<Failure, String>> insertShift(InsertShiftParams params);

  Future<Either<Failure, List<ShiftModel>>> fetchAllShifts(
      NoParams noParams);

  Future<Either<Failure, int>> updateShift(UpdateShiftParams params);

  Future<Either<Failure, int>> deleteShift(int id);
}

class ShiftDataSourceImpl implements ShiftDataSource {
  final SQLFLiteFFIConsumer _databaseConsumer;
  final SupabaseConsumer _supabaseConsumer;

  ShiftDataSourceImpl(this._databaseConsumer, this._supabaseConsumer);

  @override
  Future<Either<Failure, String>> insertShift(InsertShiftParams params) async {
    try {
      final data = {
        'total_collected_money': params.totalCollectedMoney,
        'start_time': params.fromTime.toUtc().toIso8601String(),
        'end_time': params.toTime.toUtc().toIso8601String(),
        'user_id': params.userId,
        'shift_user_name': params.userName
      };
      logger(params.fromTime.toUtc());
      logger(params.toTime.toUtc());
      return await _supabaseConsumer.insert('shifts', data);
      // Insert data into the 'shifts' table
      // return await _databaseConsumer.add('shifts', data);
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to insert shift: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ShiftModel>>> fetchAllShifts(
      NoParams noParams) async {
    try {
      final result = await _supabaseConsumer.getAll('shifts');
      return result.fold((l) => Left(l), (data) {
        final shifts = data.map((e) => ShiftModel.fromJson(e)).toList();
        return Right(shifts);
      });
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
  final String userId;
  final String userName;

  InsertShiftParams({
    required this.totalCollectedMoney,
    required this.fromTime,
    required this.toTime,
    required this.userId,
    required this.userName,
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
