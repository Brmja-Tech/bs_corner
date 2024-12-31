import 'package:get_it/get_it.dart';
import 'package:pscorner/features/timers/data/datasources/timers_data_source.dart';
import 'package:pscorner/features/timers/presentation/blocs/timers_cubit.dart';

class TimerServiceLocator {
  static Future<void> execute({required GetIt sl}) async {
    sl.registerSingleton<TimersDataSource>(TimersDataSourceImp(sl()));
    sl.registerLazySingleton(() => TimersCubit(sl()));
  }
}
