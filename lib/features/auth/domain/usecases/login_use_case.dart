import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:pscorner/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase extends BaseUseCase<Map<String, dynamic>?, AuthParams> {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  @override
  Future<Either<Failure, Map<String, dynamic>?>> call(AuthParams params) {
    return _authRepository.login(params);
  }
}
