import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_state.dart';
import 'package:pscorner/features/rooms/data/datasources/rooms_data_source.dart';
import 'package:pscorner/features/rooms/domain/usecases/clear_room_table_use_case.dart';
import 'package:pscorner/features/rooms/domain/usecases/delete_room_consumption_use_case.dart';
import 'package:pscorner/features/rooms/domain/usecases/delete_room_use_case.dart';
import 'package:pscorner/features/rooms/domain/usecases/fetch_all_rooms_use_case.dart';
import 'package:pscorner/features/rooms/domain/usecases/fetch_room_consmption_use_case.dart';
import 'package:pscorner/features/rooms/domain/usecases/insert_room_consmption_use_case.dart';
import 'package:pscorner/features/rooms/domain/usecases/insert_room_use_case.dart';
import 'package:pscorner/features/rooms/domain/usecases/transfer_room_data_use_case.dart';
import 'package:pscorner/features/rooms/domain/usecases/update_room_use_case.dart';
import 'rooms_state.dart';

class RoomsBloc extends Cubit<RoomsState> {
  RoomsBloc(
      this._insertRoomUseCase,
      this._deleteRoomUseCase,
      this._fetchAllRoomsUseCase,
      this._updateRoomUseCase,
      this._clearRoomTableUseCase,
      this._transferRoomDataUseCase,
      this._insertRoomConsumptionUseCase,
      this._fetchRoomConsumptionUseCase,
      this._deleteRoomConsumptionUseCase)
      : super(const RoomsState()) {
    _fetchAllItems();
  }

  final InsertRoomUseCase _insertRoomUseCase;
  final DeleteRoomUseCase _deleteRoomUseCase;
  final ClearRoomTableUseCase _clearRoomTableUseCase;
  final FetchAllRoomsUseCase _fetchAllRoomsUseCase;
  final UpdateRoomUseCase _updateRoomUseCase;
  final TransferRoomDataUseCase _transferRoomDataUseCase;
  final InsertRoomConsumptionUseCase _insertRoomConsumptionUseCase;
  final FetchRoomConsumptionUseCase _fetchRoomConsumptionUseCase;
  final DeleteRoomConsumptionUseCase _deleteRoomConsumptionUseCase;

  Future<void> insertItem({
    required String deviceType,
  }) async {
    emit(state.copyWith(status: RoomsStateStatus.loading));
    final result = await _insertRoomUseCase(InsertRoomParams(
      deviceType: deviceType,
      state: 'not running',
      openTime: false,
      isMultiplayer: false,
      price: calculatePrice(deviceType, false),
    ));

    result.fold((failure) {
      loggerError('failure ${failure.message}');
      emit(state.copyWith(
          status: RoomsStateStatus.error, errorMessage: failure.message));
    }, (id) {
      logger('id $id');
      final newRoom = {
        'id': id,
        'device_type': deviceType,
        'state': 'not running',
        'open_time': 0,
        'price': calculatePrice(deviceType, false),
        'is_multiplayer': false
      };
      emit(state.copyWith(
          status: RoomsStateStatus.success, rooms: [newRoom, ...state.rooms]));
    });
  }

  Future<void> deleteItem(int id) async {
    emit(state.copyWith(status: RoomsStateStatus.loading));
    final result = await _deleteRoomUseCase(id);

    result.fold((failure) {
      emit(state.copyWith(
          status: RoomsStateStatus.error, errorMessage: failure.message));
    }, (id) {
      emit(state.copyWith(status: RoomsStateStatus.success));
    });
  }

  Future<void> updateItem(
      {required int id,
      String? deviceType,
      String? roomState,
      bool? openTime,
      bool? isMultiplayer,
      num? price}) async {
    loggerWarn(id);
    emit(state.copyWith(status: RoomsStateStatus.loading));
    final result = await _updateRoomUseCase(UpdateRoomParams(
      id: id,
      price: price,
      deviceType: deviceType,
      isMultiplayer: isMultiplayer,
      openTime: openTime,
      state: roomState,
    ));

    result.fold((failure) {
      loggerError('failure ${failure.message}');
      emit(state.copyWith(
          status: RoomsStateStatus.error, errorMessage: failure.message));
    }, (updated) {
      // logger('result ${state.rooms[id]['is_multiplayer']}');
      final updatedRooms = state.rooms.map((room) {
        if (room['id'] == id) {
          return {
            ...room, // Copy existing data
            if (deviceType != null) 'device_type': deviceType,
            if (roomState != null) 'state': roomState,
            if (openTime != null) 'open_time': openTime ? 1 : 0,
            if (isMultiplayer != null) 'is_multiplayer': isMultiplayer ? 1 : 0,
            if (price != null) 'price': price
          };
        }
        return room;
      }).toList();
      emit(state.copyWith(
          status: RoomsStateStatus.success, rooms: updatedRooms));
    });
  }

  Future<void> _fetchAllItems() async {
    emit(state.copyWith(status: RoomsStateStatus.loading));
    final result = await _fetchAllRoomsUseCase(const NoParams());
    result.fold((failure) {
      emit(state.copyWith(
          status: RoomsStateStatus.error, errorMessage: failure.message));
    }, (items) {
      emit(state.copyWith(status: RoomsStateStatus.success, rooms: items));
    });
  }

  Future<void> clearRooms() async {
    emit(state.copyWith(status: RoomsStateStatus.loading));
    final result = await _clearRoomTableUseCase('rooms');
    result.fold((failure) {
      emit(state.copyWith(
          status: RoomsStateStatus.error, errorMessage: failure.message));
    }, (items) {
      emit(state.copyWith(status: RoomsStateStatus.success, rooms: []));
    });
  }

  double calculatePrice(String deviceType, bool isMultiplayer) {
    if (deviceType == 'PS4') {
      return isMultiplayer ? 30.0 : 20.0;
    } else if (deviceType == 'PS5') {
      return isMultiplayer ? 50.0 : 30.0;
    }
    return 0.0; // Default price if unknown device
  }

  Future<void> transferRoomData({
    required int sourceId,
    required int targetId,
    required String targetState,
    required bool targetIsMultiplayer,
    required bool targetOpenTime,
    required targetPrice,
    required String targetElapsedTime,
  }) async {
    emit(state.copyWith(status: RoomsStateStatus.loading));

    final result = await _transferRoomDataUseCase(
      TransferRoomDataParams(sourceRoomId: sourceId, targetRoomId: targetId),
    );

    result.fold(
      (failure) {
        emit(state.copyWith(
            status: RoomsStateStatus.error, errorMessage: failure.message));
      },
      (_) {
        // Update the rooms in the state
        final updatedRooms = state.rooms.map((room) {
          if (room['id'] == sourceId) {
            // Reset the source room to default values
            return {
              ...room,
              'state': 'not running',
              'is_multiplayer': 0,
              'open_time': 0,
              'price': 0
            };
          } else if (room['id'] == targetId) {
            // Update the target room with provided inputs
            return {
              ...room,
              'state': targetState,
              'is_multiplayer': targetIsMultiplayer ? 1 : 0,
              'open_time': targetOpenTime ? 1 : 0,
              'price': targetPrice,
              'time': targetElapsedTime,
            };
          }
          return room;
        }).toList();
        loggerWarn(updatedRooms.toString());
        emit(state.copyWith(
            status: RoomsStateStatus.success, rooms: updatedRooms));
      },
    );
  }

  Future<void> fetchRoomConsumptions(int roomId) async {
    emit(state.copyWith(status: RoomsStateStatus.loading));
    final result = await _fetchRoomConsumptionUseCase(roomId);
    result.fold((failure) {
      loggerError('failure ${failure.message}');
      emit(state.copyWith(
          status: RoomsStateStatus.error, errorMessage: failure.message));
    }, (items) {
      logger('items $items');
      emit(state.copyWith(
          status: RoomsStateStatus.success, roomConsumptions: items));
    });
  }

  Future<void> insertRoomConsumption({
    required BuildContext context,
    required List<ItemQuantity> quantity,
    required int roomId,
  }) async {
    emit(state.copyWith(status: RoomsStateStatus.loading));
    final result =
        await _insertRoomConsumptionUseCase(BatchInsertConsumptionParams(
      roomId: roomId,
      dataList: quantity,
    ));
    result.fold((failure) {
      loggerError('failure ${failure.message}');
      emit(state.copyWith(
          status: RoomsStateStatus.error, errorMessage: failure.message));
      context.pop();
    }, (consumptionId) {
      logger('Successfully inserted consumption with id:');
      emit(state.copyWith(status: RoomsStateStatus.success, roomConsumptions: [
        ...state.roomConsumptions,
      ]));
      context.pop();
    });
  }

  Future<void> deleteRoomConsumption({
    required int id,
  }) async {
    emit(state.copyWith(status: RoomsStateStatus.loading));
    final result = await _deleteRoomConsumptionUseCase(id);
    result.fold((failure) {
      loggerError('failure ${failure.message}');
      emit(state.copyWith(
          status: RoomsStateStatus.error, errorMessage: failure.message));
    }, (consumptionId) {

      logger('Successfully deleted consumption with id: $consumptionId');
      emit(state.copyWith(status: RoomsStateStatus.success));
    });
  }

  List<Map<String, dynamic>> get availableRooms =>
      state.rooms.where((room) => room['state'] == 'not running').toList();
}
