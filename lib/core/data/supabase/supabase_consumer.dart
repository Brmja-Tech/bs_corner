import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/errors/supabase_exception.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/core/enums/user_role_enum.dart';
import 'package:pscorner/core/extensions/string_extension.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/identity/user_identity.dart';
import 'package:pscorner/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:pscorner/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class SupabaseConsumer<T> {
  // Initialize Supabase
  Future<Either<Failure, String?>> uploadImage(File image, String fileName);

  // User Authentication
  Future<Either<Failure, void>> signIn(AuthParams params);

  Future<Either<Failure, void>> register(RegisterParams params);
  

  Future<Either<Failure, void>> signOut();

  // Data Operations
  Future<Either<Failure, String>> insert(String table, T data);

  Future<Either<Failure, bool>> update(
      String table, Map<String, dynamic> updates,
      {required Map<String, dynamic> filters});

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
      {Map<String, dynamic>? filters}) async {
    try {
      var query = _client.from(table).select();

      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      final response = await query.single();
      logger('Data fetched successfully from $table: $response');

      return Right(response as T);
    } catch (e) {
      loggerError('Failed to fetch data from $table: $e');
      return Left(CreateFailure(message: 'Failed to fetch data: $e'));
    }
  }

  @override
  Future<Either<Failure, List<T>>> getAll(String table,
      {Map<String, dynamic>? filters}) async {
    try {
      var query = _client.from(table).select();

      if (filters != null) {
        filters.forEach((key, value) {
          query = query.eq(key, value);
        });
      }

      final response = await query;
      logger('Data fetched successfully from $table: $response');

      // Cast each record to the generic type T
      final dataList = (response as List).map((json) => json as T).toList();
      return Right(dataList);
    } catch (e, stackTrace) {
      if (e is SupabaseException) {
        loggerError('StackTrace: $stackTrace');
        return Left(UnknownFailure(message: e.message));
      }
      loggerError('Failed to fetch data from $table: $e');
      return Left(CreateFailure(message: 'Failed to fetch data: $e'));
    }
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
  Future<Either<Failure, String>> insert(String table, T data) async {
    try {
      final response =
          await _client.from(table).insert(data as Object).select().single();

      logger('Data inserted successfully into $response');
      return Right(response['id'].toString());
    } catch (e, stackTrace) {
      if (e is SupabaseException) {
        loggerError('StackTrace: $stackTrace');
        return Left(UnknownFailure(message: e.message));
      }
      loggerError('Failed to insert data into $table: $e');
      return Left(CreateFailure(message: 'Failed to insert data: $e'));
    }
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
  Future<Either<Failure, void>> register(RegisterParams params) async {
    try {
      final user =
          await _client.from('users').insert(params.toJson()).select().single();
      UserData.setUser(UserModel.fromJson(user));
      logger('User registered successfully');
      return Right(null);
    } catch (e) {
      loggerError('Failed to register user: $e');
      return Left(CreateFailure(message: 'Failed to register user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> signIn(AuthParams params) async {
    try {
      // Query the database for the user with the provided username and password
      final response = await _client
          .from('users')
          .select()
          .eq('name', params.username)
          .eq('password', params.password)
          .single();

      final userModel = UserModel.fromJson(response);

      UserData.setUser(userModel);

      logger('User logged in successfully');
      return Right(null);
    } catch (e) {
      loggerError('Failed to log in: $e');
      return Left(AuthFailure('Invalid username or password'));
    }
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
  Future<Either<Failure, bool>> update(
    String table,
    Map<String, dynamic> updates, {
    required Map<String, dynamic> filters,
  }) async {
    try {
      if (filters.isEmpty) {
        throw ArgumentError('Filters cannot be empty for update operation.');
      }

      var query = _client.from(table).update(updates);

      filters.forEach((key, value) {
        query = query.eq(key, value);
      });

      final response = await query;

      logger(
          'Data updated successfully in $table with filters $filters: $updates $response');
      return Right(true);
    } catch (e) {
      loggerError('Failed to update data in $table: $e');
      return Left(CreateFailure(message: 'Failed to update data: $e'));
    }
  }

  @override
  Future<Either<Failure, String?>> uploadImage(
      File image, String fileName) async {
    try {
      await _client.storage.from('items_image').upload(fileName, image);
      final imageUrl =
          _client.storage.from('items_image').getPublicUrl(fileName);
      loggerWarn('Image uploaded successfully $imageUrl');
      return Right(imageUrl);
    } catch (e) {
      loggerError('Failed to upload image: $e');
      return Left(CreateFailure(message: 'Failed to upload image: $e'));
    }
  }
}

class RegisterParams extends Equatable {
  final String username;
  final String password;
  final UserRole role;

  const RegisterParams({
    required this.username,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() =>
      {'name': username, 'password': password, 'role': role.name.capitalize};

  @override
  List<Object?> get props => [username, password, role];
}
