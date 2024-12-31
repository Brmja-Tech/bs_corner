import 'package:pscorner/core/data/errors/failure.dart';
import 'package:pscorner/core/data/utils/either.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class RoomsRepo {
  Future<Either<Failure, Map<String, dynamic>>> insertARoom(
      {required String name});
}

class RoomsRepoImpl implements RoomsRepo {
  final SupabaseClient _supabaseClient;
  const RoomsRepoImpl(this._supabaseClient);
  @override
   Future<Either<Failure, Map<String, dynamic>>> insertARoom(
      {required String name}) {
    try {
      final response = _supabaseClient.from('rooms').insert({
        'title': name,
      }).select().single();
      return response.then((value) {
        
          return Right(value);
        
      });
    } catch (e) {
      return Future.value(Left(CreateFailure(message: e.toString())));
    }
  }
}
