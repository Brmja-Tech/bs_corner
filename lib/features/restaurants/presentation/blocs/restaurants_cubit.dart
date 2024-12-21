import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/features/restaurants/data/datasources/restaurants_data_source.dart';
import 'package:pscorner/features/restaurants/domain/usecases/delete_restaurant_item_use_case.dart';
import 'package:pscorner/features/restaurants/domain/usecases/fetch_all_restaurants_department_use_case.dart';
import 'package:pscorner/features/restaurants/domain/usecases/insert_restaurant_item_use_case.dart';
import 'package:pscorner/features/restaurants/domain/usecases/update_restaurant_item_use_case.dart';
import 'restaurants_state.dart';

class RestaurantsBloc extends Cubit<RestaurantsState> {
  RestaurantsBloc(
      this._insertRestaurantItemUseCase,
      this._deleteRestaurantItemUseCase,
      this._updateRestaurantItemUseCase,
      this._fetchAllRestaurantsDepartmentUseCase)
      : super(const RestaurantsState());

  final InsertRestaurantItemUseCase _insertRestaurantItemUseCase;
  final DeleteRestaurantItemUseCase _deleteRestaurantItemUseCase;
  final UpdateRestaurantItemUseCase _updateRestaurantItemUseCase;
  final FetchAllRestaurantsDepartmentUseCase
      _fetchAllRestaurantsDepartmentUseCase;

  Future<void> insertItem({
    required String name,
    required String imagePath,
    required num price,
    required String type,
  }) async {
    emit(state.copyWith(status: RestaurantsStateStatus.loading));
    final result = await _insertRestaurantItemUseCase(InsertItemParams(
      name: name,
      imagePath: imagePath,
      price: price,
      type: type,
    ));

    result.fold((failure) {
      loggerError('failure ${failure.message}');
      emit(state.copyWith(
          status: RestaurantsStateStatus.error, errorMessage: failure.message));
    }, (id) {
      logger('id $id');
      emit(state.copyWith(status: RestaurantsStateStatus.success, restaurants: [
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

    // Check if the item is already in the selected items list based on the 'id'
    final isAlreadySelected =
        selectedItems.any((selectedItem) => selectedItem['id'] == item['id']);

    if (!isAlreadySelected) {
      selectedItems.add(item); // Add the item if not already selected
      emit(state.copyWith(selectedItems: selectedItems));
      loggerWarn('Item added: $item');
    } else {
      loggerWarn('Item already selected: $item');
    }
  }
}
