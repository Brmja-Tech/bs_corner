import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/core/extensions/string_extension.dart';
import 'package:pscorner/features/auth/data/models/user_model.dart';

abstract interface class EmployeeDataSource {
  Future<Either<Failure, String>> insertEmployee(RegisterParams params);

  Future<Either<Failure, List<UserModel>>> fetchAllEmployees(NoParams noParams);

  Future<Either<Failure, int>> updateEmployee(UpdateEmployeeParams params);

  Future<Either<Failure, int>> deleteEmployee(String id);
}

class EmployeeDataSourceImpl implements EmployeeDataSource {
  final SQLFLiteFFIConsumer _databaseConsumer;
  final SupabaseConsumer _supabaseConsumer;

  EmployeeDataSourceImpl(this._databaseConsumer, this._supabaseConsumer);

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  @override
  Future<Either<Failure, String>> insertEmployee(RegisterParams params) async {
    try {
      final hashedPassword = _hashPassword(params.password);

      final data = {
        'name': params.username,
        'password': hashedPassword,
        'role': params.role.name.capitalize,
      };

      // Insert data into the 'users' table
      return await _supabaseConsumer.insert('users', data);
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to insert employee: $e'));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> fetchAllEmployees(
      NoParams noParams) async {
    try {
      final result = await _supabaseConsumer.getAll('users');
      return result.fold(
        (failure) => Left(failure),
        (data) {
          final employees = data.map((e) => UserModel.fromJson(e)).toList();
          return Right(employees);
        },
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to fetch employees: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> updateEmployee(
      UpdateEmployeeParams params) async {
    try {
      final result =
          await _supabaseConsumer.update('users', params.updates, filters: {
        'id': params.updates['id'],
      });
      return result.fold(
          (failure) => Left(failure), (data) => Right(data ? 1 : 0));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to update employee: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> deleteEmployee(String id) async {
    final result = await _supabaseConsumer.delete('users', filters: {'id': id});
    return result.fold(
        (l) => Left(
            UnknownFailure(message: 'Failed to delete employee: ${l.message}')),
        (r) => Right(r ? 1 : 0));
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
  final Map<String, dynamic> updates;

  UpdateEmployeeParams({
    required this.updates,
  });
}
