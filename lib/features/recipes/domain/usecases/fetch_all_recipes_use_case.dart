import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/recipes/data/models/recipe_model.dart';
import 'package:pscorner/features/recipes/domain/repositories/recipes_repository.dart';

class FetchAllRecipesUseCase extends BaseUseCase<List<RecipeModel>, NoParams> {
  final RecipesRepository repository;
  const FetchAllRecipesUseCase(this.repository);

  @override
  Future<Either<Failure, List<RecipeModel>>> call(NoParams params) async {
    return await repository.fetchAllRecipes(params);
  }
}