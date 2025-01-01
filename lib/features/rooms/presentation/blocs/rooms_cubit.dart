import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/features/restaurants/data/repos/repo.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_state.dart';
import 'package:pscorner/features/rooms/data/datasources/rooms_data_source.dart';
import 'package:pscorner/features/rooms/data/models/room_model.dart';
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
      this._roomsRepoImpl,
      this._deleteRoomUseCase,
      this._fetchAllRoomsUseCase,
      this._updateRoomUseCase,
      this._clearRoomTableUseCase,
      this._transferRoomDataUseCase,
      this._insertRoomConsumptionUseCase,
      this._fetchRoomConsumptionUseCase,
      this._deleteRoomConsumptionUseCase,
      this._insertRoomUseCase)
      : super(const RoomsState()) {
    _fetchAllItems();
  }
  final RoomsRepoImpl _roomsRepoImpl;
  final DeleteRoomUseCase _deleteRoomUseCase;
  final ClearRoomTableUseCase _clearRoomTableUseCase;
  final FetchAllRoomsUseCase _fetchAllRoomsUseCase;
  final UpdateRoomUseCase _updateRoomUseCase;
  final TransferRoomDataUseCase _transferRoomDataUseCase;
  final InsertRoomConsumptionUseCase _insertRoomConsumptionUseCase;
  final FetchRoomConsumptionUseCase _fetchRoomConsumptionUseCase;
  final DeleteRoomConsumptionUseCase _deleteRoomConsumptionUseCase;
  final InsertRoomUseCase _insertRoomUseCase;
  Future<void> insertRoom({
    required String deviceType,
  }) async {
    emit(state.copyWith(status: RoomsStateStatus.loading));
    final result = await _insertRoomUseCase(
      InsertRoomParams(
        deviceType: deviceType,
        state: 'state',
        openTime: true,
        isMultiplayer: true,
        price: 0.0,
      ),
    );
    result.fold((failure) {
      emit(state.copyWith(
          status: RoomsStateStatus.error, errorMessage: failure.message));
    }, (id) {
      logger('id $id');
      final newRoom = RoomModel(id: id, title: deviceType, isActive: false);
      emit(state.copyWith(
          status: RoomsStateStatus.success, rooms: [...state.rooms, newRoom]));
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
      {required String id, bool? isActive, String? title}) async {
    emit(state.copyWith(status: RoomsStateStatus.loading));
    final updates = <String, dynamic>{};
    if (isActive != null) updates['is_active'] = isActive;
    if (title != null) updates['title'] = title;
    updates['id'] = id;

    final result = await _updateRoomUseCase(UpdateParams(
      updates: updates,
    ));

    result.fold((failure) {
      loggerError('failure ${failure.message}');
      emit(state.copyWith(
          status: RoomsStateStatus.error, errorMessage: failure.message));
    }, (updated) {
      final updatedRooms = state.rooms.map((room) {
        if (room.id == id) {
          return RoomModel(
              id: room.id, title: title ?? room.title, isActive: isActive ?? room.isActive);
        } else {
          return room;
        }
      }).toList();
      emit(state.copyWith(status: RoomsStateStatus.success,rooms: updatedRooms));
    });
  }

  Future<void> _fetchAllItems() async {
    emit(state.copyWith(status: RoomsStateStatus.loading));
    final result = await _fetchAllRoomsUseCase(const NoParams());
    result.fold((failure) {
      emit(state.copyWith(
          status: RoomsStateStatus.error, errorMessage: failure.message));
    }, (items) {
      // logger(items);
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
    required String sourceId,
    required String targetId,
    required String targetState,
    required bool targetIsMultiplayer,
    required bool targetOpenTime,
    required num targetPrice,
    required String? targetElapsedTime,
    required String? targetElapsedMultiTime,
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
        emit(state.copyWith(status: RoomsStateStatus.success));
      },
    );
  }

  Future<void> fetchRoomConsumptions(String roomId) async {
    emit(state.copyWith(status: RoomsStateStatus.loading));
    final result = await _fetchRoomConsumptionUseCase(roomId);
    result.fold((failure) {
      loggerError('failure ${failure.message}');
      emit(state.copyWith(
          status: RoomsStateStatus.error, errorMessage: failure.message));
    }, (items) {
      logger('Successfully fetched consumptions $items');
      emit(state.copyWith(
          status: RoomsStateStatus.success, roomConsumptions: items));
    });
  }

  Future<void> insertRoomConsumption({
    required BuildContext context,
    required List<ItemQuantity> quantity,
    required String roomId,
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

  List<RoomModel> get availableRooms =>
      state.rooms.where((room) => room.title == 'PS4').toList();
}
