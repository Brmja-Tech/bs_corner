import 'package:equatable/equatable.dart';
import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_state.dart';
import 'package:pscorner/features/rooms/data/models/room_model.dart';

abstract interface class RoomDataSource {
  Future<Either<Failure, String>> insertRoom(InsertRoomParams params);

  Future<Either<Failure, List<RoomModel>>> fetchAllRooms(NoParams noParams);

  Future<Either<Failure, int>> deleteRoom(int id);

  Future<Either<Failure, void>> clearTable(String tableName);

  Future<Either<Failure, int>> updateRoom(UpdateParams params);

  Future<Either<Failure, void>> transferRoomData(TransferRoomDataParams params);

  Future<Either<Failure, void>> insertRoomConsumption(
      BatchInsertConsumptionParams params);

  Future<Either<Failure, List<Map<String, dynamic>>>>
      fetchRoomConsumptionsByRoom(String roomId);

  Future<Either<Failure, int>> updateRoomConsumption(
      InsertRoomConsumptionParams params);

  Future<Either<Failure, int>> deleteRoomConsumption(int id);

  Future<Either<Failure, List<Map<String, dynamic>>>>
      fetchRoomConsumptionsWithDetails(int roomId);
}

class RoomDataSourceImpl implements RoomDataSource {
  final SQLFLiteFFIConsumer _databaseConsumer;
  final SupabaseConsumer _supabaseConsumer;

  RoomDataSourceImpl(this._databaseConsumer, this._supabaseConsumer);

  @override
  Future<Either<Failure, String>> insertRoom(InsertRoomParams params) async {
    try {
      final data = {
        'title': params.deviceType,
        'state': 'running',
        'price': 'price',
        'facility_id': 0,
      };

      return await _supabaseConsumer.insert('rooms', data);
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to insert room: $e'));
    }
  }

  @override
  Future<Either<Failure, List<RoomModel>>> fetchAllRooms(
      NoParams noParams) async {
    try {
      final result = await _supabaseConsumer.getAll('rooms');
      return result.fold((l) => Left(l), (data) {
        final rooms = data.map((e) => RoomModel.fromJson(e)).toList();
        return Right(rooms);
      });
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
  Future<Either<Failure, int>> updateRoom(UpdateParams params) async {
    try {
      final result =
          await _supabaseConsumer.update('rooms', params.updates, filters: {
        'id': params.updates['id'],
      });
      return result.fold(
          (failure) => Left(failure), (data) => Right(data ? 1 : 0));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to update room: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearTable(String tableName) {
    return _databaseConsumer.clearTable(tableName);
  }

  @override
  Future<VoidEither<Failure>> transferRoomData(
      TransferRoomDataParams params) async {
    try {
      // Step 1: Retrieve data from the source room
      final sourceRoom = await _databaseConsumer.get(
        'rooms',
        where: 'id = ?',
        whereArgs: [params.sourceRoomId],
      );
      return sourceRoom.fold(
          (l) => Left(UnknownFailure(message: 'error retrieving source room')),
          (right) async {
        if (right.isEmpty) {
          return Left(UnknownFailure(message: 'Source room not found'));
        }

        final roomData = right.first;

        // Step 2: Update target room
        Map<String, dynamic> mutableRoomData = Map.from(roomData);
        loggerWarn(mutableRoomData);
        mutableRoomData.remove('id'); // Now remove the ID from the copied map
        await _databaseConsumer.update(
          'rooms',
          mutableRoomData,
          where: 'id = ?',
          whereArgs: [params.targetRoomId],
        );

        // Step 3: Optional - Reset source room
        await _databaseConsumer.update(
          'rooms',
          {
            'state': 'not running',
            'time': '00:00:00',
            "multi_time": '00:00:00',
          }, // Reset state of source room
          where: 'id = ?',
          whereArgs: [params.sourceRoomId],
        );

        return Right(null); // Void result on success
      });
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to transfer room data: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> insertRoomConsumption(
      BatchInsertConsumptionParams params) async {
    try {
      final data = params.dataList.map((item) {
        return {
          'restaurant_item_id': item.id,
          'price': item.price,
          'quantity': item.quantity,
          'room_id': params.roomId,
        };
      }).toList();
      final result = await _supabaseConsumer.batchInsert(
        'room-consumption',
        data,
      );
      return result.fold((l) => Left(l), (r) => Right(null));
    } catch (e) {
      return Left(
          UnknownFailure(message: 'Failed to insert room consumptions: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
      fetchRoomConsumptionsByRoom(String roomId) async {
    try {
      final filters = {'room_id': roomId};

      final result = await _supabaseConsumer.getAll('room-consumption',filters: filters);

      return result.fold(
            (failure) => Left(failure),
            (response) => Right(response as List<Map<String, dynamic>>),
      );
    } catch (e) {
      return Left(
          UnknownFailure(message: 'Failed to fetch room consumptions: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> updateRoomConsumption(
      InsertRoomConsumptionParams params) async {
    try {
      final data = {
        'quantity': params.quantity,
        'price': params.price,
      };

      // Update the room consumption record
      return await _databaseConsumer.update(
        'room_consumptions',
        data,
        where: 'id = ?',
        whereArgs: [params.roomId],
      );
    } catch (e) {
      return Left(
          UnknownFailure(message: 'Failed to update room consumption: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> deleteRoomConsumption(int id) async {
    try {
      // Delete the room consumption record
      return await _databaseConsumer.delete(
        'room_consumptions',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return Left(
          UnknownFailure(message: 'Failed to delete room consumption: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
      fetchRoomConsumptionsWithDetails(int roomId) async {
    try {
      // Fetch room consumptions
      final consumptionsResult = await _databaseConsumer.get(
        'room_consumptions',
        where: 'room_id = ?',
        whereArgs: [roomId],
      );
      return consumptionsResult.fold((left) {
        return Left(left);
      }, (right) async {
        final List<Map<String, dynamic>> results = [];
        for (var consumption in right) {
          final restaurantId = consumption['restaurant_id'];
          final restaurantResult = await _databaseConsumer.get(
            'restaurants',
            where: 'id = ?',
            whereArgs: [restaurantId],
          );
          return restaurantResult.fold(
            (left) {
              return Left(left);
            },
            (restaurant) {
              if (restaurant.isNotEmpty) {
                final consumptionWithRestaurant = {
                  ...consumption,
                  'restaurant': restaurant[0],
                  // Add the related restaurant data
                };
                results.add(consumptionWithRestaurant);
              }

              return Right(results); // Return the results wrapped in a Right
            },
          );
        }
        return Right(right);
      });
      // For each consumption, fetch the related restaurant
    } catch (e) {
      return Left(UnknownFailure(
          message:
              'Failed to fetch room consumptions with details: $e')); // Return the failure wrapped in a Left
    }
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
  List<Object?> get props =>
      [deviceType, state, openTime, isMultiplayer, price];
}

class UpdateRoomParams extends Equatable {
  final String id; // Room ID to update
  final bool? isActive;
  final String? title;

  const UpdateRoomParams({
    required this.id,
    this.isActive,
    this.title,
  });

  @override
  List<Object?> get props => [id, isActive, title];
}

class TransferRoomDataParams extends Equatable {
  final String sourceRoomId;
  final String targetRoomId;

  const TransferRoomDataParams(
      {required this.sourceRoomId, required this.targetRoomId});

  @override
  List<Object?> get props => [sourceRoomId, targetRoomId];
}

class InsertRoomConsumptionParams extends Equatable {
  final int? roomId;
  final int? restaurantId;
  final int? quantity;
  final num? price;

  const InsertRoomConsumptionParams({
    this.roomId,
    this.restaurantId,
    this.quantity,
    this.price,
  });

  @override
  List<Object?> get props => [roomId, restaurantId, quantity, price];
}

class BatchInsertConsumptionParams extends Equatable {
  final List<ItemQuantity> dataList;
  final String roomId;

  const BatchInsertConsumptionParams({
    required this.dataList,
    required this.roomId,
  });

  @override
  List<Object?> get props => [dataList, roomId];
}
