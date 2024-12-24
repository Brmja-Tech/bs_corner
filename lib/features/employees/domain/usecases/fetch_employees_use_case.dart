import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/employees/domain/repositories/employees_repository.dart';

class FetchEmployeeUseCase
    extends BaseUseCase<List<Map<String, dynamic>>, NoParams> {
  final EmployeesRepository _employeesRepository;

  const FetchEmployeeUseCase(this._employeesRepository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(NoParams params) {
    return _employeesRepository.fetchAllEmployees(params);
  }
}
