import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/core/enums/ingredient_enum.dart';
import 'package:pscorner/features/recipes/data/models/recipe_model.dart';

abstract interface class RecipeDataSource {
  Future<Either<Failure, String>> insertRecipe(InsertRecipeParams params);

  Future<Either<Failure, List<RecipeModel>>> fetchAllRecipes(
      NoParams noParams);

  Future<Either<Failure, int>> updateRecipe(UpdateRecipeParams params);

  Future<Either<Failure, int>> deleteRecipe(int id);

  Future<Either<Failure, List<Map<String, dynamic>>>> searchRecipeByName(
      String name);
}

class RecipeDataSourceImpl implements RecipeDataSource {
  final SQLFLiteFFIConsumer _databaseConsumer;
  final SupabaseConsumer _supabaseConsumer;

  RecipeDataSourceImpl(this._databaseConsumer, this._supabaseConsumer);

  @override
  Future<Either<Failure, String>> insertRecipe(
      InsertRecipeParams params) async {
    try {
      final data = {
        'name': params.name,
        'ingredient_unit': params.ingredientName.name,
        'quantity': params.quantity
      };
      // Insert data into the 'recipes' table
      return await _supabaseConsumer.insert('recipes', data);
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to insert recipe: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RecipeModel>>> fetchAllRecipes(
      NoParams noParams) async {
    try {
      // Fetch all recipes from the 'recipes' table
       final result = await _supabaseConsumer.getAll('recipes');
       return result.fold((left)=>Left(UnknownFailure(message: 'Failed to fetch recipes: ${left.message}')),(data){
        final recipes = data.map((e)=>RecipeModel.fromJson(e)).toList();
         return Right(recipes);
       });

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
  final IngredientEnum ingredientName;
  final double quantity;

  InsertRecipeParams({
    required this.name,
    required this.ingredientName,
    required this.quantity,
  });
}

class UpdateRecipeParams {
  final int id;
  final String? name;
  final String? ingredientName;
  final double? quantity;

  UpdateRecipeParams({
    required this.id,
    this.name,
    this.ingredientName,
    this.quantity,
  });
}
