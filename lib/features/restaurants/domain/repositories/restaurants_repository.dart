import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/restaurants/data/datasources/restaurants_data_source.dart';
import 'package:pscorner/features/restaurants/data/models/restaurant_model.dart';

abstract class RestaurantsRepository {
  Future<Either<Failure, String>> insertItem(InsertItemWithRecipesParams params);

  Future<Either<Failure, List<RestaurantModel>>> fetchAllItems(NoParams noParams);

  Future<Either<Failure, int>> deleteItem(int id);

  Future<Either<Failure, int>> updateItem(UpdateItemParams params);
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchRecipesByRestaurantId(int restaurantId);

}
