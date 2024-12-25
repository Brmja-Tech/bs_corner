import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';

abstract interface class RecipeDataSource {
  Future<Either<Failure, int>> insertRecipe(InsertRecipeParams params);

  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllRecipes(
      NoParams noParams);

  Future<Either<Failure, int>> updateRecipe(UpdateRecipeParams params);

  Future<Either<Failure, int>> deleteRecipe(int id);

  Future<Either<Failure, List<Map<String, dynamic>>>> searchRecipeByName(
      String name);
}

class RecipeDataSourceImpl implements RecipeDataSource {
  final SQLFLiteFFIConsumer _databaseConsumer;

  RecipeDataSourceImpl(this._databaseConsumer);

  @override
  Future<Either<Failure, int>> insertRecipe(InsertRecipeParams params) async {
    try {
      final data = {
        'name': params.name,
        'ingredient_name': params.ingredientName,
        'quantity': params.quantity,
        'weight': params.weight,

        // Assuming restaurant ID is passed
      };

      // Insert data into the 'recipes' table
      return await _databaseConsumer.add('recipes', data);
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to insert recipe: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllRecipes(
      NoParams noParams) async {
    try {
      // Fetch all recipes from the 'recipes' table
      return await _databaseConsumer.get('recipes');
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to fetch recipes: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> updateRecipe(UpdateRecipeParams params) async {
    try {
      final data = <String, dynamic>{};

      if (params.name != null) data['name'] = params.name;
      if (params.ingredientName != null)
        data['ingredient_name'] = params.ingredientName;
      if (params.quantity != null) data['quantity'] = params.quantity;
      if (params.weight != null) data['weight'] = params.weight;
      if (params.restaurantId != null)
        data['restaurant_id'] = params.restaurantId;

      // Update recipe data in the 'recipes' table based on the recipe ID
      return await _databaseConsumer.update(
        'recipes',
        data,
        where: 'id = ?',
        whereArgs: [params.id],
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to update recipe: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> deleteRecipe(int id) async {
    try {
      // Delete recipe data from the 'recipes' table based on the recipe ID
      final result = await _databaseConsumer
          .delete('recipes', where: 'id = ?', whereArgs: [id]);
      return result.fold(
        (l) => Left(
            UnknownFailure(message: 'Failed to delete recipe: ${l.message}')),
        (r) => Right(r),
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to delete recipe: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> searchRecipeByName(
      String name) async {
    try {
      // Search for recipes by name in the 'recipes' table
      return await _databaseConsumer.get(
        'recipes',
        where: 'name LIKE ?',
        whereArgs: ['%$name%'],
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to search recipes: $e'));
    }
  }
}

class InsertRecipeParams {
  final String name;
  final String ingredientName;
  final double? quantity;
  final double? weight;

  InsertRecipeParams({
    required this.name,
    required this.ingredientName,
    this.quantity,
    this.weight,
  }) {
    assert(quantity != null || weight != null);
  }
}

class UpdateRecipeParams {
  final int id;
  final String? name;
  final String? ingredientName;
  final double? quantity;
  final double? weight;
  final int? restaurantId;

  UpdateRecipeParams({
    required this.id,
    this.name,
    this.ingredientName,
    this.quantity,
    this.weight,
    this.restaurantId,
  });
}
