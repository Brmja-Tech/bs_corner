import 'package:equatable/equatable.dart';
import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/core/helper/functions.dart';

abstract interface class RestaurantDataSource {
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllItems(
      NoParams noParams);

  Future<Either<Failure, int>> deleteItem(int id);

  Future<Either<Failure, int>> updateItem(UpdateItemParams params);

  Future<Either<Failure, int>> insertItemWithRecipes(
      InsertItemWithRecipesParams params);

  Future<Either<Failure, List<Map<String, dynamic>>>>
      fetchRecipesByRestaurantId(int restaurantId);
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
  Future<Either<Failure, int>> insertItemWithRecipes(
      InsertItemWithRecipesParams params) async {
    try {
      return await _databaseConsumer.runTransaction((txn) async {
        final restaurantData = {
          'name': params.name,
          'image': params.imagePath,
          'price': params.price,
          'type': params.type,
        };
        final restaurantId = await txn.insert('restaurants', restaurantData);

        final batch = txn.batch();

        for (final recipe in params.recipes) {
          final associationData = {
            'restaurant_id': restaurantId,
            'recipe_id': recipe.recipeId,
            'quantity': recipe.quantity,
          };
          batch.insert('restaurant_recipes', associationData);
        }

        await batch.commit(noResult: true);

        return restaurantId;
      });
    } catch (e) {
      return Left(
          UnknownFailure(message: 'Failed to insert item with recipes: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
      fetchRecipesByRestaurantId(int restaurantId) async {
    try {
      final result = await _databaseConsumer.get(
        'restaurant_recipes',
        where: 'restaurant_id = ?',
        whereArgs: [restaurantId],
      );
      return result.fold(
          (l) => Left(UnknownFailure(
              message:
                  'Failed to fetch recipes for restaurant $restaurantId: ${l.message}')),
          (right) {
        loggerWarn(right);
        return Right(right);
      });
    } catch (e) {
      return Left(UnknownFailure(
          message: 'Failed to fetch recipes for restaurant $restaurantId: $e'));
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
  final int recipeId;
  final String name;
  final String? ingredientName;
  final num? weight;
  final num? quantity;

  Recipe({
    required this.recipeId,
    required this.name,
    this.ingredientName,
    this.weight,
    this.quantity,
  }) : assert(weight != null || quantity != null);
}
