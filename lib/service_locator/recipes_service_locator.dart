import 'package:get_it/get_it.dart';
import 'package:pscorner/features/recipes/data/datasources/recipes_data_source.dart';
import 'package:pscorner/features/recipes/data/repositories/recipes_repository_impl.dart';
import 'package:pscorner/features/recipes/domain/repositories/recipes_repository.dart';
import 'package:pscorner/features/recipes/domain/usecases/delete_recipes_use_case.dart';
import 'package:pscorner/features/recipes/domain/usecases/fetch_all_recipes_use_case.dart';
import 'package:pscorner/features/recipes/domain/usecases/insert_recipes_use_case.dart';
import 'package:pscorner/features/recipes/domain/usecases/search_for_recipes_use_case.dart';
import 'package:pscorner/features/recipes/domain/usecases/update_recipes_use_case.dart';
import 'package:pscorner/features/recipes/presentation/blocs/recipes_cubit.dart';

class RecipesServiceLocator {
  static Future<void> execute({required GetIt sl}) async {
    sl.registerLazySingleton<RecipeDataSource>(
        () => RecipeDataSourceImpl(sl()));
    sl.registerLazySingleton<RecipesRepository>(
        () => RecipesRepositoryImpl(sl()));
    sl.registerFactory(() => FetchAllRecipesUseCase(sl()));
    sl.registerFactory(() => InsertRecipesUseCase(sl()));
    sl.registerFactory(() => UpdateRecipesUseCase(sl()));
    sl.registerFactory(() => DeleteRecipesUseCase(sl()));
    sl.registerFactory(() => SearchForRecipesUseCase(sl()));
    sl.registerLazySingleton<RecipesBloc>(
        () => RecipesBloc(sl(), sl(), sl(), sl(),sl()));
  }
}
