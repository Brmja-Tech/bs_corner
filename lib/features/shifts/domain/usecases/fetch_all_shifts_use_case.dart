import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/shifts/data/datasources/shifts_data_source.dart';

class FetchAllShiftsUseCase
    extends BaseUseCase<List<Map<String, dynamic>>, NoParams> {
  final ShiftDataSource _shiftDataSource;

  FetchAllShiftsUseCase(this._shiftDataSource);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(NoParams params) {
    return _shiftDataSource.fetchAllShifts(params);
  }
}
