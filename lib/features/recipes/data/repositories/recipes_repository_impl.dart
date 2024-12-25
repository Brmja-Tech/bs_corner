import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/recipes/data/datasources/recipes_data_source.dart';

import '../../domain/repositories/recipes_repository.dart';

class RecipesRepositoryImpl implements RecipesRepository {
  final RecipeDataSource _recipeDataSource;

  RecipesRepositoryImpl(this._recipeDataSource);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllRecipes(NoParams noParams) {
    return _recipeDataSource.fetchAllRecipes(noParams);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> searchRecipeByName(String name) {
    return _recipeDataSource.searchRecipeByName(name);
  }
  @override
  Future<Either<Failure, int>> insertRecipe(InsertRecipeParams params) {
    return _recipeDataSource.insertRecipe(params);
  }
  @override
  Future<Either<Failure, int>> updateRecipe(UpdateRecipeParams params) {
    return _recipeDataSource.updateRecipe(params);
  }
  @override
  Future<Either<Failure, int>> deleteRecipe(int id) {
    return _recipeDataSource.deleteRecipe(id);
  }
}
