import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/rooms/domain/repositories/rooms_repository.dart';

class FetchAllRoomsUseCase
    extends BaseUseCase<List<Map<String, dynamic>>, NoParams> {
  final RoomsRepository _roomsRepository;

  FetchAllRoomsUseCase(this._roomsRepository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(NoParams params) {
    return _roomsRepository.fetchAllRooms(params);
  }
}
