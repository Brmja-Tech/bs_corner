import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/rooms/domain/repositories/rooms_repository.dart';

class FetchRoomConsumptionUseCase extends BaseUseCase<List<Map<String, dynamic>>,String>{
  final RoomsRepository _roomsRepository;

  FetchRoomConsumptionUseCase(this._roomsRepository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(String params) {
    return _roomsRepository.fetchRoomConsumptionsWithDetails(params);
  }
}