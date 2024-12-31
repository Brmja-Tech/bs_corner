import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/auth/data/models/user_model.dart';
import 'package:pscorner/features/employees/data/datasources/employees_data_source.dart';

import '../../domain/repositories/employees_repository.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  final EmployeeDataSource _employeeDataSource;

  EmployeesRepositoryImpl(this._employeeDataSource);

  @override
  Future<Either<Failure, List<UserModel>>> fetchAllEmployees(NoParams noParams) {
    return _employeeDataSource.fetchAllEmployees(noParams);
  }

  @override
  Future<Either<Failure, String>> insertEmployee(RegisterParams params) {
    return _employeeDataSource.insertEmployee(params);
  }

  @override
  Future<Either<Failure, int>> updateEmployee(UpdateEmployeeParams params) {
    return _employeeDataSource.updateEmployee(params);
  }
  @override
  Future<Either<Failure, int>> deleteEmployee(int params) {
    return _employeeDataSource.deleteEmployee(params);
  }

}
