import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/rooms/data/datasources/rooms_data_source.dart';
import 'package:pscorner/features/rooms/domain/repositories/rooms_repository.dart';

class TransferRoomDataUseCase
    extends BaseUseCase<void, TransferRoomDataParams> {
  final RoomsRepository _roomsRepository;

  TransferRoomDataUseCase(this._roomsRepository);

  @override
  Future<Either<Failure, void>> call(TransferRoomDataParams params) {
    return _roomsRepository.transferRoomData(params);
  }
}
