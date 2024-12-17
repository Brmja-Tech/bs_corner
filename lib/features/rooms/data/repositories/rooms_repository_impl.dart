import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/rooms/data/datasources/rooms_data_source.dart';

import '../../domain/repositories/rooms_repository.dart';

class RoomsRepositoryImpl implements RoomsRepository {
  final RoomDataSource _roomDataSource;

  RoomsRepositoryImpl(this._roomDataSource);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchAllRooms(NoParams noParams) {
    return _roomDataSource.fetchAllRooms(noParams);
  }

  @override
  Future<Either<Failure, int>> deleteRoom(int id) {
    return _roomDataSource.deleteRoom(id);
  }

  @override
  Future<Either<Failure, int>> insertRoom(InsertRoomParams params) {
    return _roomDataSource.insertRoom(params);
  }

  @override
  Future<Either<Failure, int>> updateRoom(UpdateRoomParams params) {
    return _roomDataSource.updateRoom(params);
  }
}
