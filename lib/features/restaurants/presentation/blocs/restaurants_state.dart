import 'package:equatable/equatable.dart';
import 'package:pscorner/features/restaurants/data/datasources/restaurants_data_source.dart';
import 'package:pscorner/features/restaurants/data/models/restaurant_model.dart';

enum RestaurantsStateStatus { initial, loading, success, error, added }

extension RestaurantsStateStatusX on RestaurantsState {
  bool get isLoading => status == RestaurantsStateStatus.loading;

  bool get isSuccess => status == RestaurantsStateStatus.success;

  bool get isError => status == RestaurantsStateStatus.error;

  bool get isInitial => status == RestaurantsStateStatus.initial;

  bool get isAdded => status == RestaurantsStateStatus.added;
}

class RestaurantsState extends Equatable {
  final RestaurantsStateStatus status;
  final String? errorMessage;
  final List<RestaurantModel> restaurants;
  final List<RestaurantModel> selectedItems;
  final List<Recipe> recipes;
  final List<ItemQuantity> quantity;

  const RestaurantsState({
    this.status = RestaurantsStateStatus.initial,
    this.errorMessage,
    this.restaurants = const [],
    this.selectedItems = const [],
    this.quantity = const [],
    this.recipes = const [],
  });

  RestaurantsState copyWith({
    RestaurantsStateStatus? status,
    List<RestaurantModel>? restaurants,
    List<RestaurantModel>? selectedItems,
    List<Recipe>? recipes,
    List<ItemQuantity>? quantity,
    String? errorMessage,
  }) {
    return RestaurantsState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedItems: selectedItems ?? this.selectedItems,
      quantity: quantity ?? this.quantity,
      recipes: recipes ?? this.recipes,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        restaurants,
        recipes,
        selectedItems,
        quantity,
      ];
}

class ItemQuantity extends Equatable {
  final String id;
  final num price;
  final int quantity;

  const ItemQuantity(
      {required this.id, required this.price, required this.quantity});

  @override
  List<Object?> get props => [id, price, quantity];
}
