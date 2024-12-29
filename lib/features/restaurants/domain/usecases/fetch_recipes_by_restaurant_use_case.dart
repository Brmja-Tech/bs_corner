import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/restaurants/domain/repositories/restaurants_repository.dart';

class FetchRecipesByRestaurantUseCase extends BaseUseCase<List<Map<String, dynamic>>, int> {
  final RestaurantsRepository _restaurantsRepository;

  FetchRecipesByRestaurantUseCase(this._restaurantsRepository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(int params) async {
    return await _restaurantsRepository.fetchRecipesByRestaurantId(params);
  }
}
