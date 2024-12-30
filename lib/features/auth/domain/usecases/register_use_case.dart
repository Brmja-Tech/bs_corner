import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase extends BaseUseCase<void,RegisterParams>{
  final AuthRepository _authRepository;

  RegisterUseCase(this._authRepository);
  @override
  Future<Either<Failure, void>> call(RegisterParams params) {
    return _authRepository.registerUser(params);
  }
}