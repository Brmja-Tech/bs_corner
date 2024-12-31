import 'package:get_it/get_it.dart';
import 'package:pscorner/features/facilities/data/datasources/facilities_data_source.dart';
import 'package:pscorner/features/facilities/presentation/blocs/facilities_cubit.dart';

class FacilitiesServiceLocator {
  static Future<void> execute({required GetIt sl}) async {
    sl.registerSingleton(() => FacilitiesDataSourceImp(sl()));
    sl.registerLazySingleton(() => FacilitiesCubit(sl()));
  }
}
