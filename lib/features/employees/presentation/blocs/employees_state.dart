import 'package:equatable/equatable.dart';
import 'package:pscorner/features/auth/data/models/user_model.dart';

enum EmployeesStateStatus { initial, loading, success, failure }

extension EmployeesStateStatusX on EmployeesState {
  bool get isLoading => status == EmployeesStateStatus.loading;

  bool get isSuccess => status == EmployeesStateStatus.success;

  bool get isError => status == EmployeesStateStatus.failure;

  bool get isInitial => status == EmployeesStateStatus.initial;
}

class EmployeesState extends Equatable {
  final EmployeesStateStatus status;
  final List<UserModel> employees;
  final String? errorMessage;

  const EmployeesState({
    this.status = EmployeesStateStatus.initial,
    this.employees = const [],
    this.errorMessage,
  });

  EmployeesState copyWith({
    EmployeesStateStatus? status,
    List<UserModel>? employees,
    String? errorMessage,
  }) {
    return EmployeesState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, employees, errorMessage];
}
