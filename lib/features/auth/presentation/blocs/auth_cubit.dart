import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/enums/user_role_enum.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/identity/user_identity.dart';
import 'package:pscorner/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:pscorner/features/auth/domain/usecases/login_use_case.dart';
import 'package:pscorner/features/auth/domain/usecases/register_use_case.dart';
import 'auth_state.dart';

class AuthBloc extends Cubit<AuthState> {
  AuthBloc(this._loginUseCase, this._registerUseCase)
      : super(const AuthState());
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;

  Future<void> login(String username, String password) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    final result =
        await _loginUseCase(AuthParams(username: username, password: password));
    result.fold((left) {
      emit(state.copyWith(
          status: AuthStateStatus.error, errorMessage: left.message));
    }, (right) {
      logger('user is  $right');
      emit(state.copyWith(status: AuthStateStatus.success,user: UserData.model!));
    });
  }

  Future<void> register(String username, String password) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    final result = await _registerUseCase(RegisterParams(
        username: username, password: password, role: UserRole.admin));
    result.fold((left) {
      loggerError(left.message);
      emit(state.copyWith(
          status: AuthStateStatus.error, errorMessage: left.message));
    }, (right) {
      emit(state.copyWith(status: AuthStateStatus.success,user: UserData.model!));
    });
  }
}
