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

  const RestaurantsState({
    this.status = RestaurantsStateStatus.initial,
    this.errorMessage,
    this.restaurants = const [],
  });

  RestaurantsState copyWith({
    RestaurantsStateStatus? status,
    List<Map<String, dynamic>>? restaurants,
    String? errorMessage,
  }) {
    return RestaurantsState(
      status: status ?? this.status,
      restaurants: restaurants ?? this.restaurants,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage,restaurants];
}
