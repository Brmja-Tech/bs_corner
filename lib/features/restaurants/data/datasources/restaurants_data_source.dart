import 'package:equatable/equatable.dart';
import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';

abstract interface class RestaurantDataSource {

  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllItems(
      NoParams noParams);

  Future<Either<Failure, int>> deleteItem(int id);

  Future<Either<Failure, int>> updateItem(UpdateItemParams params);

  Future<Either<Failure, int>> insertItemWithRecipes(
      InsertItemWithRecipesParams params);
}

class RestaurantDataSourceImpl implements RestaurantDataSource {
  final SQLFLiteFFIConsumer _databaseConsumer;

  RestaurantDataSourceImpl(this._databaseConsumer);



  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllItems(
      NoParams noParams) async {
    try {
      return await _databaseConsumer.get('restaurants');
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to fetch items: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> deleteItem(int id) async {
    try {
      return await _databaseConsumer.delete(
        'restaurants',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to delete item: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> updateItem(UpdateItemParams params) async {
    try {
      final data = <String, dynamic>{};

      if (params.name != null) data['name'] = params.name;
      if (params.imagePath != null) data['image'] = params.imagePath;
      if (params.price != null) data['price'] = params.price;
      if (params.type != null) data['type'] = params.type;

      return await _databaseConsumer.update(
        'restaurants',
        data,
        where: 'id = ?',
        whereArgs: [params.id],
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to update item: $e'));
    }
  }
  @override
  Future<Either<Failure, int>> insertItemWithRecipes(InsertItemWithRecipesParams params) async {
    try {
      return await _databaseConsumer.runTransaction((txn) async {
        // Insert restaurant item
        final restaurantData = {
          'name': params.name,
          'image': params.imagePath,
          'price': params.price,
          'type': params.type,
        };
        final restaurantId = await txn.insert('restaurants', restaurantData);

        // Insert recipes associated with the restaurant
        for (final recipe in params.recipes) {
          final recipeData = {
            'ingredient_name': recipe.ingredientName,
            'name': recipe.name,
            'weight': recipe.weight,
            'quantity': recipe.quantity,
            'restaurant_id': restaurantId,
          };
          await txn.insert('recipes', recipeData);
        }

        return restaurantId;
      });
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to insert item with recipes: $e'));
    }
  }

}

class InsertItemParams extends Equatable {
  final String name;
  final String imagePath;
  final num price;
  final String type;

  const InsertItemParams({
    required this.name,
    required this.imagePath,
    required this.price,
    required this.type,
  });

  @override
  List<Object?> get props => [name, imagePath, price, type];
}

class UpdateItemParams extends Equatable {
  final int id;
  final String? name;
  final String? imagePath;
  final num? price;
  final String? type;

  const UpdateItemParams({
    required this.id,
    this.name,
    this.imagePath,
    this.price,
    this.type,
  });

  @override
  List<Object?> get props => [id, name, imagePath, price, type];
}

class InsertItemWithRecipesParams {
  final String name;
  final String imagePath;
  final double price;
  final String type;
  final List<Recipe> recipes;

  InsertItemWithRecipesParams({
    required this.name,
    required this.imagePath,
    required this.price,
    required this.type,
    required this.recipes,
  });
}

class Recipe {
  final String name;
  final String ingredientName;
  final num? weight;
  final num? quantity;

  Recipe({
    required this.name,
    required this.ingredientName,
    this.weight,
    this.quantity,
  }) : assert(weight != null || quantity != null);
}
