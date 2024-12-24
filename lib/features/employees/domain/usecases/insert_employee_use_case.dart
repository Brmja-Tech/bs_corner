import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/employees/data/datasources/employees_data_source.dart';
import 'package:pscorner/features/employees/domain/repositories/employees_repository.dart';

class InsertEmployeeUseCase extends BaseUseCase<int, InsertEmployeeParams> {
  final EmployeesRepository _employeesRepository;

  const InsertEmployeeUseCase(this._employeesRepository);

  @override
  Future<Either<Failure, int>> call(InsertEmployeeParams params) {
    return _employeesRepository.insertEmployee(params);
  }
}
