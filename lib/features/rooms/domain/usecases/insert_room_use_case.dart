import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/rooms/data/datasources/rooms_data_source.dart';
import 'package:pscorner/features/rooms/domain/repositories/rooms_repository.dart';

class InsertRoomUseCase extends BaseUseCase<String, InsertRoomParams> {
  final RoomsRepository _roomsRepository;

  InsertRoomUseCase(this._roomsRepository);

  @override
  Future<Either<Failure, String>> call(InsertRoomParams params) {
    return _roomsRepository.insertRoom(params);
  }
}
