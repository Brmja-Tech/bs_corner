import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/enums/ingredient_enum.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/features/recipes/data/datasources/recipes_data_source.dart';
import 'package:pscorner/features/recipes/domain/usecases/delete_recipes_use_case.dart';
import 'package:pscorner/features/recipes/domain/usecases/fetch_all_recipes_use_case.dart';
import 'package:pscorner/features/recipes/domain/usecases/insert_recipes_use_case.dart';
import 'package:pscorner/features/recipes/domain/usecases/search_for_recipes_use_case.dart';
import 'package:pscorner/features/recipes/domain/usecases/update_recipes_use_case.dart';
import 'recipes_state.dart';

class RecipesBloc extends Cubit<RecipesState> {
  RecipesBloc(
      this._fetchAllRecipesUseCase,
      this._updateRecipesUseCase,
      this._deleteRecipesUseCase,
      this._searchForRecipesUseCase,
      this._insertRecipesUseCase)
      : super(const RecipesState()) {
    fetchAllRecipes();
  }

  final FetchAllRecipesUseCase _fetchAllRecipesUseCase;
  final UpdateRecipesUseCase _updateRecipesUseCase;
  final DeleteRecipesUseCase _deleteRecipesUseCase;
  final SearchForRecipesUseCase _searchForRecipesUseCase;
  final InsertRecipesUseCase _insertRecipesUseCase;

  Future<void> fetchAllRecipes() async {
    emit(state.copyWith(status: RecipesStateStatus.loading));

    final result = await _fetchAllRecipesUseCase(const NoParams());
    result.fold((failure) {
      loggerError(failure.message);
      emit(state.copyWith(errorMessage: failure.message));
    }, (recipes) {
      logger(recipes);
      emit(
          state.copyWith(recipes: recipes, status: RecipesStateStatus.success));
    });
  }

  @override
  void onChange(Change<RecipesState> change) {
    super.onChange(change);
    logger(change.nextState.status);
    logger(change.currentState.status);
  }

  Future<void> insertRecipe({
    required double quantity,
    required String name,
    double? weight,
    required IngredientEnum ingredientName,
  }) async {
    emit(state.copyWith(status: RecipesStateStatus.loading));

    final result = await _insertRecipesUseCase(InsertRecipeParams(
      quantity: quantity,
      name: name,
      ingredientName: ingredientName,
    ));
    result.fold((failure) {
      loggerError(failure.message);
      emit(state.copyWith(errorMessage: failure.message,status: RecipesStateStatus.error));
    }, (success) {
      logger(success);
      emit(state.copyWith(status: RecipesStateStatus.success, recipes: [
        ...state.recipes,
        {
          'id': success,
          'quantity': quantity,
          'name': name,
          'weight': weight,
          'ingredient_name': ingredientName
        }
      ]));
    });
  }

  Future<void> updateRecipe({
    required int id,
    double? quantity,
    String? name,
    double? weight,
    String? ingredientName,
  }) async {
    emit(state.copyWith(status: RecipesStateStatus.loading));

    final result = await _updateRecipesUseCase(UpdateRecipeParams(
      id: id,
      quantity: quantity,
      name: name,
      ingredientName: ingredientName,
    ));
    result
        .fold((failure) => emit(state.copyWith(errorMessage: failure.message)),
            (success) {
      logger(success);
      emit(state.copyWith(status: RecipesStateStatus.success));
    });
  }

  Future<void> deleteRecipe(int id) async {
    emit(state.copyWith(status: RecipesStateStatus.loading));

    final result = await _deleteRecipesUseCase(id);
    result
        .fold((failure) => emit(state.copyWith(errorMessage: failure.message)),
            (success) {
      logger(success);
      emit(state.copyWith(
          status: RecipesStateStatus.success,
          recipes: [...state.recipes.where((element) => element['id'] != id)]));
    });
  }

  Future<void> searchRecipeByName(String name) async {
    emit(state.copyWith(status: RecipesStateStatus.loading));

    final result = await _searchForRecipesUseCase(name);
    result
        .fold((failure) => emit(state.copyWith(errorMessage: failure.message)),
            (recipes) {
      logger(recipes);
      emit(
          state.copyWith(recipes: recipes, status: RecipesStateStatus.success));
    });
  }
}
