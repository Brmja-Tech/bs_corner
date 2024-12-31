import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/enums/user_role_enum.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/features/auth/data/models/user_model.dart';
import 'package:pscorner/features/employees/data/datasources/employees_data_source.dart';
import 'package:pscorner/features/employees/domain/usecases/delete_empolyee_use_case.dart';
import 'package:pscorner/features/employees/domain/usecases/fetch_employees_use_case.dart';
import 'package:pscorner/features/employees/domain/usecases/insert_employee_use_case.dart';
import 'package:pscorner/features/employees/domain/usecases/update_employee_use_case.dart';
import 'employees_state.dart';

class EmployeesBloc extends Cubit<EmployeesState> {
  EmployeesBloc(this._insertEmployeeUseCase, this._updateEmployeeUseCase,
      this._deleteEmployeeUseCase, this._getAllEmployeesUseCase)
      : super(const EmployeesState()) {
    fetchAllEmployees();
  }

  final InsertEmployeeUseCase _insertEmployeeUseCase;
  final UpdateEmployeeUseCase _updateEmployeeUseCase;
  final DeleteEmployeeUseCase _deleteEmployeeUseCase;
  final FetchEmployeeUseCase _getAllEmployeesUseCase;

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<void> insertEmployee(
      {required String username,
      required String password,
      required UserRole role}) async {
    emit(state.copyWith(status: EmployeesStateStatus.loading));
    final result = await _insertEmployeeUseCase(RegisterParams(
      username: username,
      password: _hashPassword(password),
      role: role,
    ));
    result.fold((left) {
      loggerError(left.message);
      emit(state.copyWith(
          status: EmployeesStateStatus.failure, errorMessage: left.message));
    }, (right) {
      emit(state.copyWith(
        status: EmployeesStateStatus.success,
        employees: [
          ...state.employees,
          UserModel(
              id: right.toString(),
              username: username,
              role: role.name,
              password: password)
        ],
      ));
    });
  }

  Future<void> updateEmployee({
    required String id,
    String? username,
    String? password,
    String? role,
  }) async {
    emit(state.copyWith(status: EmployeesStateStatus.loading));
    final updates = <String, dynamic>{};
    updates['id'] = id;
    if (username != null) updates['name'] = username;
    if (password != null) updates['password'] = password;
    if (role != null) updates['role'] = role;

    final result =
        await _updateEmployeeUseCase(UpdateEmployeeParams(updates: updates));
    if (updates.isEmpty) {
      emit(state.copyWith(
        status: EmployeesStateStatus.failure,
        errorMessage: 'No fields provided for update.',
      ));
      return;
    }
    result.fold((left) {
      loggerError(left.message);
      emit(state.copyWith(
        status: EmployeesStateStatus.failure,
        errorMessage: left.message,
      ));
    }, (right) {
      final updatedEmployees = state.employees.map((user) {
        if (user.id == id) {
          return user.copyWith(
            username: username ?? user.username,
            password: password ?? user.password,
            role: role ?? user.role,
          );
        }
        return user;
      }).toList();

      emit(state.copyWith(
        status: EmployeesStateStatus.success,
        employees: updatedEmployees,
      ));
    });
    logger(state.employees);
  }

  Future<void> deleteEmployee({required String id}) async {
    emit(state.copyWith(status: EmployeesStateStatus.loading));
    final result = await _deleteEmployeeUseCase(id);
    result.fold((left) {
      loggerError(left.message);
      emit(state.copyWith(
          status: EmployeesStateStatus.failure, errorMessage: left.message));
    }, (right) {
      emit(state.copyWith(
        status: EmployeesStateStatus.success,
        employees: state.employees
            .where((employee) => employee.id != id.toString())
            .toList(),
      ));
    });
  }

  Future<void> fetchAllEmployees() async {
    emit(state.copyWith(status: EmployeesStateStatus.loading));
    final result = await _getAllEmployeesUseCase(const NoParams());
    result.fold((left) {
      loggerError(left.message);
      emit(state.copyWith(
          status: EmployeesStateStatus.failure, errorMessage: left.message));
    }, (right) {
      emit(state.copyWith(
        status: EmployeesStateStatus.success,
        employees: right,
      ));
    });
  }
}
