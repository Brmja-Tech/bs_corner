import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/recipes/domain/repositories/recipes_repository.dart';

class FetchAllRecipesUseCase extends BaseUseCase<List<Map<String, dynamic>>, NoParams> {
  final RecipesRepository repository;
  const FetchAllRecipesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(NoParams params) async {
    return await repository.fetchAllRecipes(params);
  }
}