import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/auth/data/datasources/auth_local_data_source.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> registerUser(RegisterParams params);

  Future<Either<Failure, Map<String, dynamic>?>> login(AuthParams params);
}
