import 'package:equatable/equatable.dart';

enum RoomsStateStatus { initial, loading, success, error }

extension RoomsStateStatusX on RoomsState {
  bool get isLoading => status == RoomsStateStatus.loading;

  bool get isSuccess => status == RoomsStateStatus.success;

  bool get isError => status == RoomsStateStatus.error;

  bool get isInitial => status == RoomsStateStatus.initial;
}

class RoomsState extends Equatable {
  final RoomsStateStatus status;
  final String errorMessage;
  final List<Map<String, dynamic>> rooms;

  const RoomsState({
    this.status = RoomsStateStatus.initial,
    this.errorMessage = '',
    this.rooms = const [],
  });

  RoomsState copyWith({
    RoomsStateStatus? status,
    String? errorMessage,
    List<Map<String, dynamic>>? rooms,
  }) {
    return RoomsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      rooms: rooms ?? this.rooms,
    );
  }

  @override
  List<Object> get props => [status, errorMessage, rooms];
}
