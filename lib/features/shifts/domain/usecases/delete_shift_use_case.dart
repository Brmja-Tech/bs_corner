import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/shifts/data/datasources/shifts_data_source.dart';

import '../../../../core/data/utils/base_use_case.dart';

class DeleteShiftUseCase extends BaseUseCase<int, int> {
  final ShiftDataSource _shiftDataSource;

  DeleteShiftUseCase(this._shiftDataSource);

  @override
  Future<Either<Failure, int>> call(int params) {
    return _shiftDataSource.deleteShift(params);
  }
}
