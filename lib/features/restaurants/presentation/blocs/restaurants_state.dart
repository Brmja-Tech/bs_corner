import 'package:equatable/equatable.dart';

enum RestaurantsStateStatus { initial, loading, success, error }

extension RestaurantsStateStatusX on RestaurantsState {
  bool get isLoading => status == RestaurantsStateStatus.loading;

  bool get isSuccess => status == RestaurantsStateStatus.success;

  bool get isError => status == RestaurantsStateStatus.error;

  bool get isInitial => status == RestaurantsStateStatus.initial;
}

class RestaurantsState extends Equatable {
  final RestaurantsStateStatus status;
  final String? errorMessage;
  final List<Map<String, dynamic>> restaurants;
  final List<Map<String, dynamic>> selectedItems;

  const RestaurantsState({
    this.status = RestaurantsStateStatus.initial,
    this.errorMessage,
    this.restaurants = const [],
    this.selectedItems = const [],
  });

  RestaurantsState copyWith({
    RestaurantsStateStatus? status,
    List<Map<String, dynamic>>? restaurants,
    List<Map<String, dynamic>>? selectedItems,
    String? errorMessage,
  }) {
    return RestaurantsState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, restaurants, selectedItems];
}
