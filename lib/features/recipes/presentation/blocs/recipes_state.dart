import 'package:equatable/equatable.dart';

enum RecipesStateStatus { initial, loading, success, error }

extension RecipesStateStatusX on RecipesState {
  bool get isLoading => status == RecipesStateStatus.loading;

  bool get isSuccess => status == RecipesStateStatus.success;

  bool get isError => status == RecipesStateStatus.error;

  bool get isInitial => status == RecipesStateStatus.initial;
}

class RecipesState extends Equatable {
  final RecipesStateStatus status;
  final List<Map<String, dynamic>> recipes;
  final String errorMessage;

  const RecipesState({
    this.status = RecipesStateStatus.initial,
    this.recipes = const [],
    this.errorMessage = '',
  });

  RecipesState copyWith({
    RecipesStateStatus? status,
    List<Map<String, dynamic>>? recipes,
    String? errorMessage,
  }) {
    return RecipesState(
      status: status ?? this.status,
      recipes: recipes ?? this.recipes,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, recipes, errorMessage];
}
