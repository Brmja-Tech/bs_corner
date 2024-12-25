import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/recipes/domain/repositories/recipes_repository.dart';

class DeleteRecipesUseCase extends BaseUseCase<int, int> {
  final RecipesRepository _recipesRepository;
  const DeleteRecipesUseCase(this._recipesRepository);

  @override
  Future<Either<Failure, int>> call(int params) async {
    return await _recipesRepository.deleteRecipe(params);
  }
}