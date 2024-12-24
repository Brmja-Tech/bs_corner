import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/shifts/data/datasources/shifts_data_source.dart';

abstract class ShiftsRepository {
  Future<Either<Failure, int>> insertShift(InsertShiftParams params);

  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllShifts(
      NoParams noParams);

  Future<Either<Failure, int>> updateShift(UpdateShiftParams params);

  Future<Either<Failure, int>> deleteShift(int id);
}
