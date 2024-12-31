import 'package:get_it/get_it.dart';
import 'package:pscorner/features/shifts/data/datasources/shifts_data_source.dart';
import 'package:pscorner/features/shifts/data/repositories/shifts_repository_impl.dart';
import 'package:pscorner/features/shifts/domain/repositories/shifts_repository.dart';
import 'package:pscorner/features/shifts/domain/usecases/delete_shift_use_case.dart';
import 'package:pscorner/features/shifts/domain/usecases/fetch_all_shifts_use_case.dart';
import 'package:pscorner/features/shifts/domain/usecases/insert_shift_use_case.dart';
import 'package:pscorner/features/shifts/domain/usecases/update_shift_use_case.dart';
import 'package:pscorner/features/shifts/presentation/blocs/shifts_cubit.dart';

class ShiftServiceLocator{
  static Future<void> execute({required GetIt sl}) async {
    sl.registerLazySingleton<ShiftDataSource>(() => ShiftDataSourceImpl(sl(),sl()));
    sl.registerLazySingleton<ShiftsRepository>(() => ShiftsRepositoryImpl(sl()));
    sl.registerFactory(() => FetchAllShiftsUseCase(sl()));
    sl.registerFactory(() => UpdateShiftUseCase(sl()));
    sl.registerFactory(() => DeleteShiftUseCase(sl()));
    sl.registerFactory(() => InsertShiftUseCase(sl()));
    sl.registerLazySingleton<ShiftsBloc>(() => ShiftsBloc(sl(),sl(),sl(),sl()));
  }

}