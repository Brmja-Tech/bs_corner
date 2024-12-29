import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/either.dart';

abstract interface class SupabaseConsumer<T> {
  Future<Either<Failure, void>> initSupabase();

  Future<Either<Failure, void>> signIn(String email, String password);

  Future<Either<Failure, void>> register();

  Future<Either<Failure, T>> insert(String table, T data);

  Future<Either<Failure, T>> update(String table, T data);

  Future<Either<Failure, T>> get(String table);

  Future<Either<Failure, T>> delete(String table);
}
