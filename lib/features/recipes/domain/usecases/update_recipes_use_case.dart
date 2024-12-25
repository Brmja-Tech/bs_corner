import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/recipes/data/datasources/recipes_data_source.dart';

class UpdateRecipesUseCase extends BaseUseCase<int, UpdateRecipeParams> {
  final RecipeDataSource _recipeDataSource;

  UpdateRecipesUseCase(this._recipeDataSource);

  @override
  Future<Either<Failure, int>> call(UpdateRecipeParams params) =>
      _recipeDataSource.updateRecipe(params);
}
