import 'package:equatable/equatable.dart';

enum ReportsStateStatus { initial, loading, success, error }

extension ReportsStateStatusX on ReportsState {
  bool get isLoading => status == ReportsStateStatus.loading;

  bool get isSuccess => status == ReportsStateStatus.success;

  bool get isError => status == ReportsStateStatus.error;

  bool get isInitial => status == ReportsStateStatus.initial;
}

class ReportsState extends Equatable {
  final ReportsStateStatus status;
  final String? errorMessage;

  const ReportsState(
      {this.status = ReportsStateStatus.initial,this.errorMessage});

  ReportsState copyWith({
    ReportsStateStatus? status,
    String? errorMessage,
  }) {
    return ReportsState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
