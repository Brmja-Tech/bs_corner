import 'package:equatable/equatable.dart';

enum AuthStateStatus { initial, loading, success, error }

extension AuthStateStatusX on AuthState {
  bool get isLoading => status == AuthStateStatus.loading;
  bool get isSuccess => status == AuthStateStatus.success;
  bool get isError => status == AuthStateStatus.error;
  bool get isInitial => status == AuthStateStatus.initial;
}

class AuthState extends Equatable {
  final AuthStateStatus status;
  final String? errorMessage;
  final Map<String, dynamic>? user;

  const AuthState({
    this.status = AuthStateStatus.initial,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    AuthStateStatus? status,
    Map<String, dynamic>? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, user];
}
