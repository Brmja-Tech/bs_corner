import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
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
      : super(const RecipesState()){
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
    result
        .fold((failure) => emit(state.copyWith(errorMessage: failure.message)),
            (recipes) {
      logger(recipes);
      emit(
          state.copyWith(recipes: recipes, status: RecipesStateStatus.success));
    });
  }

  Future<void> insertRecipe(
      {required double quantity,
      required String name,
      required double weight,
      required String ingredientName,
      required int restaurantId}) async {
    emit(state.copyWith(status: RecipesStateStatus.loading));

    final result = await _insertRecipesUseCase(InsertRecipeParams(
      quantity: quantity,
      name: name,
      weight: weight,
      ingredientName: ingredientName,
      restaurantId: restaurantId,
    ));
    result
        .fold((failure) => emit(state.copyWith(errorMessage: failure.message)),
            (success) {
      logger(success);
      emit(state.copyWith(status: RecipesStateStatus.success));
    });
  }

  Future<void> updateRecipe(
      {required int id,
      double? quantity,
      String? name,
      double? weight,
      String? ingredientName,
      int? restaurantId}) async {
    emit(state.copyWith(status: RecipesStateStatus.loading));

    final result = await _updateRecipesUseCase(UpdateRecipeParams(
      id: id,
      quantity: quantity,
      name: name,
      weight: weight,
      ingredientName: ingredientName,
      restaurantId: restaurantId,
    ));
    result
        .fold((failure) => emit(state.copyWith(errorMessage: failure.message)),
            (success) {
      logger(success);
      emit(state.copyWith(status: RecipesStateStatus.success, recipes: [
        ...state.recipes,
        {
          'id': id,
          'quantity': quantity,
          'name': name,
          'weight': weight,
          'ingredientName': ingredientName,
          'restaurantId': restaurantId
        }
      ]));
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
