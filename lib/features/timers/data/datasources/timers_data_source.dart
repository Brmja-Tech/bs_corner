import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/either.dart';

abstract class TimersDataSource {
  Future<Either<Failure, String>> insertATimer({required String roomId});
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
      return _supabaseConsumer.insert('table', data).then((value) {
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
}
