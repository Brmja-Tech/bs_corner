import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/employees/domain/repositories/employees_repository.dart';

class DeleteEmployeeUseCase extends BaseUseCase<int, int> {
  final EmployeesRepository _employeesRepository;

  const DeleteEmployeeUseCase(this._employeesRepository);

  @override
  Future<Either<Failure, int>> call(int params) {
    return _employeesRepository.deleteEmployee(params);
  }
}
