import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/rooms/domain/repositories/rooms_repository.dart';

class UpdateRoomUseCase extends BaseUseCase<int, UpdateParams>{
  final RoomsRepository _roomsRepository;

  UpdateRoomUseCase(this._roomsRepository);

  @override
  Future<Either<Failure, int>> call(UpdateParams params) {
    return _roomsRepository.updateRoom(params);
  }

}