import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SupabaseConsumer<T> {
  // Initialize Supabase
  Future<Either<Failure, void>> initSupabase();

  // User Authentication
  Future<Either<Failure, void>> signIn(String email, String password);
  Future<Either<Failure, dynamic>> register(String email, String password);
  Future<Either<Failure, void>> signOut();

  // Data Operations
  Future<Either<Failure, T>> insert(String table, T data);
  Future<Either<Failure, T>> update(String table, T data);
  Future<Either<Failure, T>> get(String table, {Map<String, dynamic>? filters});
  Future<Either<Failure, List<T>>> getAll(String table,
      {Map<String, dynamic>? filters});
  Future<Either<Failure, void>> delete(String table, String id);

  // Real-Time Subscriptions
  Stream<Either<Failure, T>> subscribeToTable(String table);
  Future<Either<Failure, void>> unsubscribeFromTable(String table);

  // Batch Operations
  Future<Either<Failure, List<T>>> batchInsert(String table, List<T> data);
  Future<Either<Failure, List<T>>> batchUpdate(String table, List<T> data);
  Future<Either<Failure, void>> batchDelete(String table, List<String> ids);

  // Utility Methods
  Future<Either<Failure, bool>> isAuthenticated();
  Future<Either<Failure, T>> getById(String table, String id);
  Future<Either<Failure, void>> resetPassword(String email);

  // Query with Filters
  Future<Either<Failure, List<T>>> query(String table,
      {Map<String, dynamic>? filters});

  // Error Handling
  Future<Either<Failure, void>> handleError(dynamic error);
}

class SupabaseConsumerImpl<T> implements SupabaseConsumer<T> {
  final SupabaseClient _client;

  SupabaseConsumerImpl(this._client);
  @override
  Future<Either<Failure, void>> batchDelete(String table, List<String> ids) {
    // TODO: implement batchDelete
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<T>>> batchInsert(String table, List<T> data) {
    // TODO: implement batchInsert
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<T>>> batchUpdate(String table, List<T> data) {
    // TODO: implement batchUpdate
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> delete(String table, String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, T>> get(String table,
      {Map<String, dynamic>? filters}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<T>>> getAll(String table,
      {Map<String, dynamic>? filters}) {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, T>> getById(String table, String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> handleError(error) {
    // TODO: implement handleError
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> initSupabase() {
    // TODO: implement initSupabase
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, T>> insert(String table, T data) {
    // TODO: implement insert
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() {
    // TODO: implement isAuthenticated
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<T>>> query(String table,
      {Map<String, dynamic>? filters}) {
    // TODO: implement query
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, dynamic>> register(
      String email, String password) async {
    try {
      final response = await _client
          .from('users')
          .insert({'email': email, 'password': password});
      return response.fold(
        (failure) {
          print(response.toString());
          logger(failure.toString());
          return Left(failure);
        },
        (data) => Right(data),
      );
    } catch (e) {
      throw UnknownFailure(message: 'Failed to register user: $e');
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> signIn(String email, String password) {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Stream<Either<Failure, T>> subscribeToTable(String table) {
    // TODO: implement subscribeToTable
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> unsubscribeFromTable(String table) {
    // TODO: implement unsubscribeFromTable
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, T>> update(String table, T data) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
