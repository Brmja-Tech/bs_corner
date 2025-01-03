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
  final List<Map<String, dynamic>> roomConsumptions;

  const RoomsState({
    this.status = RoomsStateStatus.initial,
    this.errorMessage = '',
    this.rooms = const [],
    this.roomConsumptions = const [],
  });

  RoomsState copyWith({
    RoomsStateStatus? status,
    String? errorMessage,
    List<Map<String, dynamic>>? rooms,
    List<Map<String, dynamic>>? roomConsumptions,
  }) {
    return RoomsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      rooms: rooms ?? this.rooms,
      roomConsumptions: roomConsumptions ?? this.roomConsumptions,
    );
  }

  @override
  List<Object> get props => [status, errorMessage, rooms];
}
