import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/features/restaurants/data/datasources/restaurants_data_source.dart';
import 'package:pscorner/features/restaurants/domain/usecases/delete_restaurant_item_use_case.dart';
import 'package:pscorner/features/restaurants/domain/usecases/fetch_all_restaurants_department_use_case.dart';
import 'package:pscorner/features/restaurants/domain/usecases/fetch_recipes_by_restaurant_use_case.dart';
import 'package:pscorner/features/restaurants/domain/usecases/insert_restaurant_item_use_case.dart';
import 'package:pscorner/features/restaurants/domain/usecases/update_restaurant_item_use_case.dart';
import 'restaurants_state.dart';

class RestaurantsBloc extends Cubit<RestaurantsState> {
  RestaurantsBloc(
      this._insertRestaurantItemUseCase,
      this._deleteRestaurantItemUseCase,
      this._updateRestaurantItemUseCase,
      this._fetchAllRestaurantsDepartmentUseCase,
      this._fetchRecipesByRestaurantUseCase)
      : super(const RestaurantsState()) {
    fetchAllItems();
  }

  final InsertRestaurantItemUseCase _insertRestaurantItemUseCase;
  final DeleteRestaurantItemUseCase _deleteRestaurantItemUseCase;
  final UpdateRestaurantItemUseCase _updateRestaurantItemUseCase;
  final FetchAllRestaurantsDepartmentUseCase
      _fetchAllRestaurantsDepartmentUseCase;
  final FetchRecipesByRestaurantUseCase _fetchRecipesByRestaurantUseCase;
  List<Recipe> recipes = [];

  Future<void> fetchRecipesByRestaurantId(int id) async {
    // logger('message');
    recipes.clear();
    emit(state.copyWith(status: RestaurantsStateStatus.loading));
    final result = await _fetchRecipesByRestaurantUseCase(id);
    result.fold((failure) {
      loggerError('failure ${failure.message}');
      emit(state.copyWith(
          status: RestaurantsStateStatus.error, errorMessage: failure.message));
    }, (recipes) {
      logger('recipes $recipes');
      emit(state.copyWith(status: RestaurantsStateStatus.success));
    });
  }

  Future<void> insertItem(
      {required String name,
      required String imagePath,
      required num price,
      required String type,
      required List<Recipe> recipes}) async {
    emit(state.copyWith(status: RestaurantsStateStatus.loading));
    final recipeObjects = recipes.map((recipe) {
      return Recipe(
        recipeId: recipe.recipeId,
        quantity: recipe.quantity,
        name: recipe.name,
      );
    }).toList();
    final result =
        await _insertRestaurantItemUseCase(InsertItemWithRecipesParams(
      name: name,
      imagePath: imagePath,
      price: price.toDouble(),
      type: type,
      recipes: recipeObjects,
    ));

    result.fold((failure) {
      loggerError('failure ${failure.message}');
      emit(state.copyWith(
          status: RestaurantsStateStatus.error, errorMessage: failure.message));
    }, (id) {
      logger('id $id');
      emit(state.copyWith(status: RestaurantsStateStatus.added, restaurants: [
        ...state.restaurants,
        {
          'id': id,
          'name': name,
          'image': imagePath,
          'price': price,
          'type': type
        }
      ]));
    });
  }

  Future<void> deleteItem(int id) async {
    emit(state.copyWith(status: RestaurantsStateStatus.loading));
    final result = await _deleteRestaurantItemUseCase(id);

    result.fold((failure) {
      emit(state.copyWith(
          status: RestaurantsStateStatus.error, errorMessage: failure.message));
    }, (id) {
      emit(state.copyWith(status: RestaurantsStateStatus.success));
    });
  }

  Future<void> updateItem({
    required int id,
    String? name,
    String? imagePath,
    num? price,
    String? type,
  }) async {
    emit(state.copyWith(status: RestaurantsStateStatus.loading));
    final result = await _updateRestaurantItemUseCase(UpdateItemParams(
      id: id,
      name: name,
      imagePath: imagePath,
      price: price,
      type: type,
    ));

    result.fold((failure) {
      emit(state.copyWith(
          status: RestaurantsStateStatus.error, errorMessage: failure.message));
    }, (id) {
      emit(state.copyWith(status: RestaurantsStateStatus.success));
    });
  }

  Future<void> fetchAllItems() async {
    emit(state.copyWith(status: RestaurantsStateStatus.loading));
    final result =
        await _fetchAllRestaurantsDepartmentUseCase(const NoParams());
    result.fold((failure) {
      emit(state.copyWith(
          status: RestaurantsStateStatus.error, errorMessage: failure.message));
    }, (items) {
      emit(state.copyWith(
          status: RestaurantsStateStatus.success, restaurants: items));
    });
  }

  void selectItem(Map<String, dynamic> item) {
    final List<Map<String, dynamic>> selectedItems = [...state.selectedItems];

    final isAlreadySelected =
        selectedItems.any((selectedItem) => selectedItem['id'] == item['id']);

    if (!isAlreadySelected) {
      selectedItems.add(item);
      emit(state.copyWith(selectedItems: selectedItems, quantity: [
        ...state.quantity,
        ItemQuantity(id: item['id'], quantity: 1, price: item['price'])
      ]));
    } else {}
  }

  void setQuantity(
      {required int id, required int quantity, required num price}) {
    final List<ItemQuantity> quantityList = [...state.quantity];
    final List<Map<String, dynamic>> selectedItems = [...state.selectedItems];

    // Check if the item already exists in the quantity list
    final existingItemIndex = quantityList.indexWhere((item) => item.id == id);

    if (existingItemIndex != -1) {
      if (quantity == 0) {
        // Remove the item from both quantity list and selected items if quantity is 0
        quantityList.removeAt(existingItemIndex);
        selectedItems.removeWhere((selectedItem) => selectedItem['id'] == id);
      } else {
        // Update the quantity of the existing item
        quantityList[existingItemIndex] = ItemQuantity(
          id: id,
          quantity: quantity,
          price: price,
        );
        // loggerWarn('Item quantity updated: $id to $quantity');
      }
    } else {
      if (quantity > 0) {
        // Add a new item with the specified quantity
        quantityList
            .add(ItemQuantity(id: id, quantity: quantity, price: price));
        if (!selectedItems.any((selectedItem) => selectedItem['id'] == id)) {
          selectedItems.add({
            'id': id,
            'price': price
          }); // Adjust selected item format as needed
        }
        // loggerWarn('Item added: $id with quantity: $quantity');
      }
    }

    emit(state.copyWith(quantity: quantityList, selectedItems: selectedItems));
  }

  double calculateTotalPrice() {
    return state.quantity.fold(0.0, (sum, item) {
      final itemPrice = item.price * item.quantity;
      return sum + itemPrice;
    });
  }

  void clearSelectedItems() {
    emit(state.copyWith(selectedItems: [], quantity: []));
  }

  void setRecipes(Recipe recipes) {
    emit(state.copyWith(recipes: [recipes, ...state.recipes]));
  }

  void clearRecipes() {
    emit(state.copyWith(recipes: []));
  }
}
