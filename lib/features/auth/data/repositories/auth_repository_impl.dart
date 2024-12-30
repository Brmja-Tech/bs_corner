import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/auth/data/datasources/auth_local_data_source.dart';

import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepositoryImpl(this._authLocalDataSource);

  @override
  Future<Either<Failure, Map<String, dynamic>?>> login(AuthParams params) {
    return _authLocalDataSource.login(params);
  }

  @override
  Future<Either<Failure, void>> registerUser(RegisterParams params) {
    return _authLocalDataSource.registerUser(params);
  }
}
