import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/rooms/domain/repositories/rooms_repository.dart';

class ClearRoomTableUseCase extends BaseUseCase<void, String> {
  final RoomsRepository _roomsRepository;

  ClearRoomTableUseCase(this._roomsRepository);

  @override
  Future<Either<Failure, void>> call(String params) {
    return _roomsRepository.clearTable(params);
  }
}
