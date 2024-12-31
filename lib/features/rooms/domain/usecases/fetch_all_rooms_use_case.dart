import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/rooms/data/models/room_model.dart';
import 'package:pscorner/features/rooms/domain/repositories/rooms_repository.dart';

class FetchAllRoomsUseCase
    extends BaseUseCase<List<RoomModel>, NoParams> {
  final RoomsRepository _roomsRepository;

  FetchAllRoomsUseCase(this._roomsRepository);

  @override
  Future<Either<Failure, List<RoomModel>>> call(NoParams params) {
    return _roomsRepository.fetchAllRooms(params);
  }
}
