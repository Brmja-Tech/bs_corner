import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/features/employees/data/datasources/employees_data_source.dart';
import 'package:pscorner/features/employees/domain/usecases/delete_empolyee_use_case.dart';
import 'package:pscorner/features/employees/domain/usecases/fetch_employees_use_case.dart';
import 'package:pscorner/features/employees/domain/usecases/insert_employee_use_case.dart';
import 'package:pscorner/features/employees/domain/usecases/update_employee_use_case.dart';
import 'employees_state.dart';

class EmployeesBloc extends Cubit<EmployeesState> {
  EmployeesBloc(this._insertEmployeeUseCase, this._updateEmployeeUseCase,
      this._deleteEmployeeUseCase, this._getAllEmployeesUseCase)
      : super(const EmployeesState());
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
      required bool isAdmin}) async {

    emit(state.copyWith(status: EmployeesStateStatus.loading));
    final result = await _insertEmployeeUseCase(InsertEmployeeParams(
      username: username,
      password: _hashPassword(password),
      isAdmin: isAdmin,
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
          {
            'id': right,
            'username': username,
            'password': _hashPassword(password),
            'isAdmin': isAdmin
          }
        ],
      ));
    });
  }

  Future<void> updateEmployee({
    required int id,
    String? username,
    String? password,
    bool? isAdmin,
  }) async {
    emit(state.copyWith(status: EmployeesStateStatus.loading));
    final result = await _updateEmployeeUseCase(UpdateEmployeeParams(
      id: id,
      username: username,
      password: password,
      isAdmin: isAdmin,
    ));
    result.fold((left) {
      loggerError(left.message);
      emit(state.copyWith(
          status: EmployeesStateStatus.failure, errorMessage: left.message));
    }, (right) {
      emit(state.copyWith(
        status: EmployeesStateStatus.success,
      ));
    });
  }

  Future<void> deleteEmployee({required int id}) async {
    emit(state.copyWith(status: EmployeesStateStatus.loading));
    final result = await _deleteEmployeeUseCase(id);
    result.fold((left) {
      loggerError(left.message);
      emit(state.copyWith(
          status: EmployeesStateStatus.failure, errorMessage: left.message));
    }, (right) {
      emit(state.copyWith(
        status: EmployeesStateStatus.success,
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
