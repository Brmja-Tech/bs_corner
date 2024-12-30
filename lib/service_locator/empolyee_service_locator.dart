import 'package:get_it/get_it.dart';
import 'package:pscorner/features/employees/data/datasources/employees_data_source.dart';
import 'package:pscorner/features/employees/data/repositories/employees_repository_impl.dart';
import 'package:pscorner/features/employees/domain/repositories/employees_repository.dart';
import 'package:pscorner/features/employees/domain/usecases/delete_empolyee_use_case.dart';
import 'package:pscorner/features/employees/domain/usecases/fetch_employees_use_case.dart';
import 'package:pscorner/features/employees/domain/usecases/insert_employee_use_case.dart';
import 'package:pscorner/features/employees/domain/usecases/update_employee_use_case.dart';
import 'package:pscorner/features/employees/presentation/blocs/employees_cubit.dart';

class EmployeeServiceLocator {
  static Future<void> execute({required GetIt sl}) async {
   sl.registerLazySingleton<EmployeeDataSource>(()=>EmployeeDataSourceImpl(sl(),sl(),));
   sl.registerLazySingleton<EmployeesRepository>(()=>EmployeesRepositoryImpl(sl()));
   sl.registerFactory(()=> FetchEmployeeUseCase(sl()));
   sl.registerFactory(()=> UpdateEmployeeUseCase(sl()));
   sl.registerFactory(()=> DeleteEmployeeUseCase(sl()));
   sl.registerFactory(()=> InsertEmployeeUseCase(sl()));
   sl.registerLazySingleton<EmployeesBloc>(()=>EmployeesBloc(sl(),sl(),sl(),sl()));
  }
}