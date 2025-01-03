import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:crypto/crypto.dart';
import 'package:pscorner/core/helper/functions.dart';

abstract interface class AuthLocalDataSource {
  Future<Either<Failure, void>> registerUser(AuthParams params);

  Future<Either<Failure, Map<String, dynamic>?>> login(AuthParams params);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SQLFLiteFFIConsumer _dbConsumer;

  AuthLocalDataSourceImpl(this._dbConsumer);

  @override
  Future<Either<Failure, void>> registerUser(AuthParams params) async {
    try {
      final hashedPassword = _hashPassword(params.password);

      // Step 2: Prepare the data to be inserted
      final data = {
        'username': params.username,
        'password': hashedPassword, // Storing the hashed password
        'isAdmin': params.isAdmin ? 1 : 0,
      };
      final result = await _dbConsumer.add('users', data);
      return result.fold(
        (failure) {
          loggerError('message ${failure.message}');
          return Left(failure);
        },
        (_) {
          logger('success');
          return Right(null);
        },
      );
    } catch (e) {
      loggerError('Failed to register user: $e');
      return Left(CreateFailure(message: 'Failed to register user: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> login(
      AuthParams params) async {
    try {
      final hashedPassword = _hashPassword(params.password);
      final result = await _dbConsumer.get(
        'users',
        where: 'username = ? AND password = ?',
        whereArgs: [params.username, hashedPassword],
      );
      return result.fold(
        (failure) => Left(failure),
        (users) {
          if (users.isEmpty) {
            return Left(AuthFailure('خطأ في تسجيل البيانات'));
          }
          final user = users.first;
          return Right(user);
        },
      );
    } catch (e) {
      return Left(AuthFailure('Login failed: $e'));
    }
  }

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}

class AuthParams extends Equatable {
  final String username;
  final String password;
  final bool isAdmin;

  const AuthParams(
      {required this.username, required this.password, this.isAdmin = false});

  @override
  List<Object?> get props => [username, password];
}
