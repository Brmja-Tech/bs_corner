import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';

abstract interface class EmployeeDataSource {
  Future<Either<Failure, int>> insertEmployee(InsertEmployeeParams params);

  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllEmployees(
      NoParams noParams);

  Future<Either<Failure, int>> updateEmployee(UpdateEmployeeParams params);

  Future<Either<Failure, int>> deleteEmployee(int id);
}

class EmployeeDataSourceImpl implements EmployeeDataSource {
  final SQLFLiteFFIConsumer _databaseConsumer;

  EmployeeDataSourceImpl(this._databaseConsumer);

  @override
  Future<Either<Failure, int>> insertEmployee(
      InsertEmployeeParams params) async {
    try {
      final data = {
        'username': params.username,
        'password': params.password,
        'isAdmin': params.isAdmin ? 1 : 0,
        // Converting boolean to integer for database
      };

      // Insert data into the 'users' table
      return await _databaseConsumer.add('users', data);
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to insert employee: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllEmployees(
      NoParams noParams) async {
    try {
      // Fetch all employees from the 'users' table
      return await _databaseConsumer.get('users');
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to fetch employees: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> updateEmployee(
      UpdateEmployeeParams params) async {
    try {
      final data = <String, dynamic>{};

      if (params.username != null) data['username'] = params.username;
      if (params.password != null) data['password'] = params.password;
      if (params.isAdmin != null) data['isAdmin'] = params.isAdmin! ? 1 : 0;

      // Update employee data in the 'users' table based on the employee ID
      return await _databaseConsumer.update(
        'users',
        data,
        where: 'id = ?',
        whereArgs: [params.id],
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to update employee: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> deleteEmployee(int id) async {
    final result = await _databaseConsumer
        .delete('users', where: 'id = ?', whereArgs: [id]);
    return result.fold(
        (l) => Left(
            UnknownFailure(message: 'Failed to delete employee: ${l.message}')),
        (r) => Right(r));
  }
}

// Define parameter classes for insert and update operations
class InsertEmployeeParams {
  final String username;
  final String password;
  final bool isAdmin;

  InsertEmployeeParams({
    required this.username,
    required this.password,
    required this.isAdmin,
  });
}

class UpdateEmployeeParams {
  final int id;
  final String? username;
  final String? password;
  final bool? isAdmin;

  UpdateEmployeeParams({
    required this.id,
    this.username,
    this.password,
    this.isAdmin,
  });
}
