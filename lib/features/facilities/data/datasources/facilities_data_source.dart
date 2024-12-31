import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/data/utils/either.dart';

abstract class FacilitiesDataSource {
  Future<Either<Failure, String>> insertFacility({required String title});
}

class FacilitiesDataSourceImp extends FacilitiesDataSource {
  final SupabaseConsumer _supabaseConsumer;
  FacilitiesDataSourceImp(this._supabaseConsumer);
  @override
  Future<Either<Failure, String>> insertFacility({required String title}) {
    try {
      final data = {
        'title': title,
      };
      return _supabaseConsumer.insert('facilities', data).then((value) {
        return value.fold((left) {
          return Left(UnknownFailure(message: 'Failed to insert the facility'));
        }, (right) {
          return Right('right');
        });
      });
    } catch (e) {
      return Future.value(Left(CreateFailure(message: e.toString())));
    }
  }
}
