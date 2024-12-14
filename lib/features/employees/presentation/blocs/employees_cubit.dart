import 'package:flutter_bloc/flutter_bloc.dart';
import 'employees_state.dart';

class EmployeesCubit extends Cubit<EmployeesState> {
  EmployeesCubit() : super(EmployeesState());
}
