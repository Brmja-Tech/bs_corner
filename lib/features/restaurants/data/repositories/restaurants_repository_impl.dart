import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/restaurants/data/datasources/restaurants_data_source.dart';

import '../../domain/repositories/restaurants_repository.dart';

class RestaurantsRepositoryImpl implements RestaurantsRepository {
  final RestaurantDataSource _restaurantRepository;

  RestaurantsRepositoryImpl(this._restaurantRepository);

  @override
  Future<Either<Failure, int>> deleteItem(int id) {
    return _restaurantRepository.deleteItem(id);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllItems(
      NoParams noParams) {
    return _restaurantRepository.fetchAllItems(noParams);
  }

  @override
  Future<Either<Failure, String>> insertItem(InsertItemWithRecipesParams params) {
    return _restaurantRepository.insertItemWithRecipes(params);
  }

  @override
  Future<Either<Failure, int>> updateItem(UpdateItemParams params) {
    return _restaurantRepository.updateItem(params);
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchRecipesByRestaurantId(int restaurantId) {
    return _restaurantRepository.fetchRecipesByRestaurantId(restaurantId);
  }
}
