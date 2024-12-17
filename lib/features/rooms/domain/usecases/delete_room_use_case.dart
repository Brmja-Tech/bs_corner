import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/rooms/domain/repositories/rooms_repository.dart';

class DeleteRoomUseCase extends BaseUseCase<int,int>{
  final RoomsRepository _roomsRepository;

  DeleteRoomUseCase(this._roomsRepository);

  @override
  Future<Either<Failure, int>> call(int params) async {
    return await _roomsRepository.deleteRoom(params);
  }
}