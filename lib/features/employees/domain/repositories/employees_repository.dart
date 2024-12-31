import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/auth/data/models/user_model.dart';
import 'package:pscorner/features/employees/data/datasources/employees_data_source.dart';

abstract class EmployeesRepository {
  Future<Either<Failure, String>> insertEmployee(RegisterParams params);

  Future<Either<Failure, List<UserModel>>> fetchAllEmployees(NoParams noParams);

  Future<Either<Failure, int>> updateEmployee(UpdateEmployeeParams params);
  Future<Either<Failure, int>> deleteEmployee(int params);
}
