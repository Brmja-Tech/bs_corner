import 'package:equatable/equatable.dart';

enum ShiftsStateStatus { initial, loading, success, error }

extension ShiftsStateStatusX on ShiftsState {
  bool get isLoading => status == ShiftsStateStatus.loading;

  bool get isSuccess => status == ShiftsStateStatus.success;

  bool get isError => status == ShiftsStateStatus.error;

  bool get isInitial => status == ShiftsStateStatus.initial;
}

class ShiftsState extends Equatable {
  final ShiftsStateStatus status;
  final String? errorMessage;
  final List<Map<String, dynamic>> shifts;

  const ShiftsState({
    this.status = ShiftsStateStatus.initial,
    this.errorMessage,
    this.shifts = const [],
  });

  ShiftsState copyWith({
    ShiftsStateStatus? status,
    String? errorMessage,
    List<Map<String, dynamic>>? shifts,
  }) {
    return ShiftsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      shifts: shifts ?? this.shifts,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, shifts];
}
