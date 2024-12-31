import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/rooms/data/datasources/rooms_data_source.dart';
import 'package:pscorner/features/rooms/data/models/room_model.dart';

abstract interface class RoomsRepository {
  Future<Either<Failure, String>> insertRoom(InsertRoomParams params);

  Future<Either<Failure, List<RoomModel>>> fetchAllRooms(
      NoParams noParams);

  Future<Either<Failure, int>> deleteRoom(int id);

  Future<Either<Failure, void>> clearTable(String tableName);

  Future<Either<Failure, void>> transferRoomData(TransferRoomDataParams params);

  Future<Either<Failure, int>> updateRoom(UpdateRoomParams params);
  Future<Either<Failure, void>> insertRoomConsumption(BatchInsertConsumptionParams params);
  Future<Either<Failure, List<Map<String, dynamic>>>> fetchRoomConsumptionsWithDetails(String roomId);
  Future<Either<Failure, int>> deleteRoomConsumption(int id);

}
