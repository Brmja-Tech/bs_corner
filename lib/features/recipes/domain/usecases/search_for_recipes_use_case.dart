import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/recipes/domain/repositories/recipes_repository.dart';

class SearchForRecipesUseCase
    extends BaseUseCase<List<Map<String, dynamic>>, String> {
  final RecipesRepository _recipesRepository;

  SearchForRecipesUseCase(this._recipesRepository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(String params) {
    return _recipesRepository.searchRecipeByName(params);
  }
}
