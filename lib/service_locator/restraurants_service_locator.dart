import 'package:get_it/get_it.dart';
import 'package:pscorner/features/restaurants/data/datasources/restaurants_data_source.dart';
import 'package:pscorner/features/restaurants/data/repositories/restaurants_repository_impl.dart';
import 'package:pscorner/features/restaurants/domain/repositories/restaurants_repository.dart';
import 'package:pscorner/features/restaurants/domain/usecases/delete_restaurant_item_use_case.dart';
import 'package:pscorner/features/restaurants/domain/usecases/fetch_all_restaurants_department_use_case.dart';
import 'package:pscorner/features/restaurants/domain/usecases/insert_restaurant_item_use_case.dart';
import 'package:pscorner/features/restaurants/domain/usecases/update_restaurant_item_use_case.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';

class RestaurantsServiceLocator {
  static Future<void> execute({required GetIt sl}) async {
    sl.registerLazySingleton<RestaurantDataSource>(()=>RestaurantDataSourceImpl(sl()));
    sl.registerLazySingleton<RestaurantsRepository>(()=>RestaurantsRepositoryImpl(sl()));
    sl.registerFactory(()=> FetchAllRestaurantsDepartmentUseCase(sl()));
    sl.registerFactory(()=> UpdateRestaurantItemUseCase(sl()));
    sl.registerFactory(()=> DeleteRestaurantItemUseCase(sl()));
    sl.registerFactory(()=> InsertRestaurantItemUseCase(sl()));
    sl.registerLazySingleton(()=> RestaurantsBloc(sl(),sl(),sl(),sl()));
  }
}