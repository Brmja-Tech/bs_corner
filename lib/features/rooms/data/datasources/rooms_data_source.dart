import 'package:equatable/equatable.dart';
import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';

abstract interface class RoomDataSource {
  Future<Either<Failure, int>> insertRoom(InsertRoomParams params);

  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllRooms(
      NoParams noParams);

  Future<Either<Failure, int>> deleteRoom(int id);

  Future<Either<Failure, void>> clearTable(String tableName);

  Future<Either<Failure, int>> updateRoom(UpdateRoomParams params);
}

class RoomDataSourceImpl implements RoomDataSource {
  final SQLFLiteFFIConsumer _databaseConsumer;

  RoomDataSourceImpl(this._databaseConsumer);

  @override
  Future<Either<Failure, int>> insertRoom(InsertRoomParams params) async {
    try {
      final data = {
        'device_type': params.deviceType, // PS4 or PS5
        'state': params.state, // running, not running, paused, pre-booked
        'open_time': params.openTime ? 1 : 0, // BOOLEAN as INTEGER (0 or 1)
        'is_multiplayer': params.isMultiplayer ? 1 : 0, // BOOLEAN as INTEGER
        'price':params.price,
      };

      return await _databaseConsumer.add('rooms', data);
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to insert room: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllRooms(
      NoParams noParams) async {
    try {
      return await _databaseConsumer.get('rooms');
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to fetch rooms: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> deleteRoom(int id) async {
    try {
      return await _databaseConsumer.delete(
        'rooms',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to delete room: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> updateRoom(UpdateRoomParams params) async {
    try {
      final data = <String, dynamic>{};

      if (params.deviceType != null) data['device_type'] = params.deviceType;
      if (params.state != null) data['state'] = params.state;
      if (params.openTime != null) data['open_time'] = params.openTime! ? 1 : 0;
      if (params.isMultiplayer != null)
        data['is_multiplayer'] = params.isMultiplayer! ? 1 : 0;

      return await _databaseConsumer.update(
        'rooms',
        data,
        where: 'id = ?',
        whereArgs: [params.id],
      );
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to update room: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearTable(String tableName) {
    return _databaseConsumer.clearTable(tableName);
  }
}

class InsertRoomParams extends Equatable {
  final String deviceType; // PS4 or PS5
  final String state; // running, not running, paused, pre-booked
  final bool openTime; // Boolean
  final bool isMultiplayer; // Boolean
  final num price;
  const InsertRoomParams({
    required this.deviceType,
    required this.state,
    required this.openTime,
    required this.isMultiplayer,
    required this.price,
  });

  @override
  List<Object?> get props => [deviceType, state, openTime, isMultiplayer,price];
}

class UpdateRoomParams extends Equatable {
  final int id; // Room ID to update
  final String? deviceType; // Optional
  final String? state; // Optional
  final bool? openTime; // Optional
  final bool? isMultiplayer; // Optional

  const UpdateRoomParams({
    required this.id,
    this.deviceType,
    this.state,
    this.openTime,
    this.isMultiplayer,
  });

  @override
  List<Object?> get props => [id, deviceType, state, openTime, isMultiplayer];
}
