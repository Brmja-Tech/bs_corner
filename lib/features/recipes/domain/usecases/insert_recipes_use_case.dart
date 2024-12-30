import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/recipes/data/datasources/recipes_data_source.dart';
import 'package:pscorner/features/recipes/domain/repositories/recipes_repository.dart';

class InsertRecipesUseCase extends BaseUseCase<String, InsertRecipeParams> {
  final RecipesRepository _recipeDataSource;

  const InsertRecipesUseCase(this._recipeDataSource);

  @override
  Future<Either<Failure, String>> call(InsertRecipeParams params) {
    return _recipeDataSource.insertRecipe(params);
  }
}
