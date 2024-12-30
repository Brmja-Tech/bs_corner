import 'package:equatable/equatable.dart';
import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/sql/sqlfilte_ffi_consumer.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_state.dart';

abstract interface class RoomDataSource {
  Future<Either<Failure, String>> insertRoom(InsertRoomParams params);

  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllRooms(
      NoParams noParams);

  Future<Either<Failure, int>> deleteRoom(int id);

  Future<Either<Failure, void>> clearTable(String tableName);

  Future<Either<Failure, int>> updateRoom(UpdateRoomParams params);

  Future<Either<Failure, void>> transferRoomData(TransferRoomDataParams params);

  Future<Either<Failure, void>> insertRoomConsumption(
      BatchInsertConsumptionParams params);

  Future<Either<Failure, List<Map<String, dynamic>>>>
      fetchRoomConsumptionsByRoom(int roomId);

  Future<Either<Failure, int>> updateRoomConsumption(
      InsertRoomConsumptionParams params);

  Future<Either<Failure, int>> deleteRoomConsumption(int id);

  Future<Either<Failure, List<Map<String, dynamic>>>>
      fetchRoomConsumptionsWithDetails(int roomId);
}

class RoomDataSourceImpl implements RoomDataSource {
  final SQLFLiteFFIConsumer _databaseConsumer;
  final SupabaseConsumer _supabaseConsumer;
  RoomDataSourceImpl(this._databaseConsumer,this._supabaseConsumer);

  @override
  Future<Either<Failure, String>> insertRoom(InsertRoomParams params) async {
    try {
      final data = {
        'title': 'VIP1',
      };

      return await _supabaseConsumer.insert('rooms', data);
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
      if (params.isMultiplayer != null) {
        data['is_multiplayer'] = params.isMultiplayer! ? 1 : 0;
      }
      if (params.price != null) data['price'] = params.price;
      if (params.time != null) data['time'] = params.time;
      if (params.multTime != null) data['multi_time'] = params.multTime;
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
      // Prepare the data list for batch insert
      final dataList = params.dataList.map((data) {
        return {
          'room_id': params.roomId,
          'restaurant_id': data.id,
          'quantity': data.quantity,
          'price': data.price,
        };
      }).toList();

      // Call batchInsert to insert all records
      return await _databaseConsumer.batchInsert(BatchInsertParams(
        table: 'room_consumptions',
        dataList: dataList,
      ));
    } catch (e) {
      return Left(
          UnknownFailure(message: 'Failed to insert room consumptions: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>>
  fetchRoomConsumptionsByRoom(int roomId) async {
    try {
      const query = '''
    SELECT 
      room_consumptions.*, 
      restaurants.* 
    FROM 
      room_consumptions
    LEFT JOIN 
      restaurants
    ON 
      room_consumptions.restaurant_id = restaurants.id
    WHERE 
      room_consumptions.room_id = ?;
    ''';

      // Execute the raw query
      return await _databaseConsumer.rawGet(
         query,
        whereArgs: [roomId],
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
  final int id; // Room ID to update
  final String? deviceType;
  final String? state;
  final bool? openTime;
  final bool? isMultiplayer;
  final num? price;
  final String? time;
  final String? multTime;

  const UpdateRoomParams({
    required this.id,
    this.deviceType,
    this.state,
    this.openTime,
    this.isMultiplayer,
    this.price,
    this.time,
    this.multTime,
  });

  @override
  List<Object?> get props =>
      [id, deviceType, state, openTime, isMultiplayer, price, time, multTime];
}

class TransferRoomDataParams extends Equatable {
  final int sourceRoomId;
  final int targetRoomId;

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
  final int roomId;

  const BatchInsertConsumptionParams({
    required this.dataList,
    required this.roomId,
  });

  @override
  List<Object?> get props => [dataList, roomId];
}
