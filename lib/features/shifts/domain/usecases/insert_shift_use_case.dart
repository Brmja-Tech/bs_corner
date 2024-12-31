import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/shifts/data/datasources/shifts_data_source.dart';

class InsertShiftUseCase extends BaseUseCase<String, InsertShiftParams> {
  final ShiftDataSource _shiftDataSource;

  InsertShiftUseCase(this._shiftDataSource);

  @override
  Future<Either<Failure, String>> call(InsertShiftParams params) {
    return _shiftDataSource.insertShift(params);
  }
}
