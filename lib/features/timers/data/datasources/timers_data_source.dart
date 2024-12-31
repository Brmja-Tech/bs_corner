import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/either.dart';

abstract class TimersDataSource {
  Future<Either<Failure, String>> insertATimer({required String roomId});
  Future<Either<Failure, String>> stopAtimer({required String roomId});
}

class TimersDataSourceImp extends TimersDataSource {
  final SupabaseConsumer _supabaseConsumer;
  TimersDataSourceImp(this._supabaseConsumer);
  @override
  Future<Either<Failure, String>> insertATimer({required String roomId}) {
    try {
      final data = {
        'room_id': roomId,
      };
      return _supabaseConsumer.insert('timers', data).then((value) {
        return value.fold((left) {
          return Left(UnknownFailure(message: 'Failed to insert timer'));
        }, (right) {
          return Right('right');
        });
      });
    } catch (e) {
      return Future.value(Left(CreateFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, String>> stopAtimer({required String roomId}) async {
    try {
      final response = await _supabaseConsumer.updateEndTime(roomId: roomId);

      return response.fold((l) {
        return Left(UnknownFailure(message: 'Failed to stop timer'));
      }, (r) {
        return Right('right');
      });
    } catch (e) {
      throw Left(UnknownFailure(message: e.toString()));
    }
  }
}
