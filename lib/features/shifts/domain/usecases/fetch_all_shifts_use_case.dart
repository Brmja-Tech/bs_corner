import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/shifts/data/models/shift_model.dart';
import 'package:pscorner/features/shifts/domain/repositories/shifts_repository.dart';

class FetchAllShiftsUseCase
    extends BaseUseCase<List<ShiftModel>, NoParams> {
  final ShiftsRepository _shiftDataSource;

  FetchAllShiftsUseCase(this._shiftDataSource);

  @override
  Future<Either<Failure, List<ShiftModel>>> call(NoParams params) {
    return _shiftDataSource.fetchAllShifts(params);
  }
}
