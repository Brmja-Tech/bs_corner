import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/restaurants/data/datasources/restaurants_data_source.dart';
import 'package:pscorner/features/restaurants/domain/repositories/restaurants_repository.dart';

class InsertRestaurantItemUseCase extends BaseUseCase<int, InsertItemWithRecipesParams> {
  final RestaurantsRepository _restaurantRepository;

  InsertRestaurantItemUseCase(this._restaurantRepository);

  @override
  Future<Either<Failure, int>> call(InsertItemWithRecipesParams params) {
    return _restaurantRepository.insertItem(params);
  }
}
