import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/core/enums/item_type_enum.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/features/restaurants/data/models/restaurant_model.dart';

abstract interface class RestaurantDataSource {
  Future<Either<Failure, List<RestaurantModel>>> fetchAllItems(
      NoParams noParams);

  Future<Either<Failure, int>> deleteItem(int id);

  Future<Either<Failure, int>> updateItem(UpdateItemParams params);

  Future<Either<Failure, String>> insertItemWithRecipes(
      InsertItemWithRecipesParams params);

  Future<Either<Failure, List<Map<String, dynamic>>>>
      fetchRecipesByRestaurantId(int restaurantId);
}

class RestaurantDataSourceImpl implements RestaurantDataSource {
  final SQLFLiteFFIConsumer _databaseConsumer;
  final SupabaseConsumer _supabaseConsumer;

  RestaurantDataSourceImpl(this._databaseConsumer, this._supabaseConsumer);

  @override
  Future<Either<Failure, List<RestaurantModel>>> fetchAllItems(
      NoParams noParams) async {
    try {
      final result = await _supabaseConsumer.getAll('restaurant-items');
      return result.fold((l) => Left(l), (data) {
        final items = data.map((e) => RestaurantModel.fromJson(e)).toList();
        return Right(items);
      });
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
  Future<Either<Failure, String>> insertItemWithRecipes(
      InsertItemWithRecipesParams params) async {
    try {
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}.jpg'; // Unique file name

      final result =
          await _supabaseConsumer.uploadImage(File(params.imagePath), fileName);
      return result.fold((left) => Left(CreateFailure(message: left.message)),
          (imagePath) {
        final data = {
          'name': params.name,
          'image': imagePath,
          'price': params.price.toString(),
          'type': params.type.name,
        };
        return _supabaseConsumer.insert('restaurant-items', data);
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
  final ItemTypeEnum type;

  // final List<Recipe> recipes;

  InsertItemWithRecipesParams({
    required this.name,
    required this.imagePath,
    required this.price,
    required this.type,
    // required this.recipes,
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
