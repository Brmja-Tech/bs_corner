import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/shifts/data/datasources/shifts_data_source.dart';
import 'package:pscorner/features/shifts/domain/repositories/shifts_repository.dart';

class UpdateShiftUseCase extends BaseUseCase<int, UpdateShiftParams> {
  final ShiftsRepository _shiftsRepository;

  UpdateShiftUseCase(this._shiftsRepository);

  @override
  Future<Either<Failure, int>> call(UpdateShiftParams params) {
    return _shiftsRepository.updateShift(params);
  }
}
