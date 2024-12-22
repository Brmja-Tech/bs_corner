import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/base_use_case.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:pscorner/features/rooms/data/datasources/rooms_data_source.dart';
import 'package:pscorner/features/rooms/domain/repositories/rooms_repository.dart';

class InsertRoomConsumptionUseCase extends BaseUseCase<void, BatchInsertConsumptionParams> {
  final RoomsRepository _roomsRepository;

  InsertRoomConsumptionUseCase(this._roomsRepository);
  @override
  Future<Either<Failure, void>> call(BatchInsertConsumptionParams params) {
    return _roomsRepository.insertRoomConsumption(params);
  }

}