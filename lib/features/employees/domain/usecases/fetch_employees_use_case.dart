import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/auth/data/models/user_model.dart';
import 'package:pscorner/features/employees/domain/repositories/employees_repository.dart';

class FetchEmployeeUseCase
    extends BaseUseCase<List<UserModel>, NoParams> {
  final EmployeesRepository _employeesRepository;

  const FetchEmployeeUseCase(this._employeesRepository);

  @override
  Future<Either<Failure, List<UserModel>>> call(NoParams params) {
    return _employeesRepository.fetchAllEmployees(params);
  }
}
