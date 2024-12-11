import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:pscorner/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase extends BaseUseCase<void,AuthParams>{
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);
  @override
  Future<Either<Failure, void>> call(AuthParams params) {
    return _authRepository.registerUser(params);
  }
}