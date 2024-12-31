import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/shifts/data/datasources/shifts_data_source.dart';

import '../../domain/repositories/shifts_repository.dart';

class ShiftsRepositoryImpl implements ShiftsRepository {
  final ShiftDataSource _shiftDataSource;

  ShiftsRepositoryImpl(this._shiftDataSource);

  @override
  Future<Either<Failure, int>> deleteShift(int id) {
    return _shiftDataSource.deleteShift(id);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllShifts(
      NoParams noParams) {
    return _shiftDataSource.fetchAllShifts(noParams);
  }

  @override
  Future<Either<Failure, String>> insertShift(InsertShiftParams params) {
    return _shiftDataSource.insertShift(params);
  }

  @override
  Future<Either<Failure, int>> updateShift(UpdateShiftParams params) {
    return _shiftDataSource.updateShift(params);
  }
}
