import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
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
      emit(state.copyWith(
          status: RestaurantsStateStatus.error, errorMessage: failure.message));
    }, (id) {
      emit(state.copyWith(status: RestaurantsStateStatus.success));
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
    required String name,
    required String imagePath,
    required num price,
    required String type,
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
}
