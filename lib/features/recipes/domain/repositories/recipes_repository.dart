import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/recipes/data/datasources/recipes_data_source.dart';

abstract class RecipesRepository {
  Future<Either<Failure, Object>> insertRecipe(InsertRecipeParams params);

  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllRecipes(NoParams noParams);

  Future<Either<Failure, int>> updateRecipe(UpdateRecipeParams params);

  Future<Either<Failure, int>> deleteRecipe(int id);

  Future<Either<Failure, List<Map<String, dynamic>>>> searchRecipeByName(String name);

}
