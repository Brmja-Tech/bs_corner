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
      final result = await _dbConsumer.add('users', {
        'username': params.username,
        'password': hashedPassword,
      });
      return result.fold(
        (failure) => Left(failure),
        (_) => Right(null),
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
            return Left(AuthFailure('قائمة المستخدمين فارغة'));
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

  const AuthParams({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}
