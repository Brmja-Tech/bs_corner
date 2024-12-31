import 'package:get_it/get_it.dart';
import 'package:pscorner/core/secrets/secrets.dart';
import 'package:pscorner/features/restaurants/data/repos/repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomsRepoImplServiceLocator {
  static Future<void> execute({required GetIt sl}) async {
    sl.registerLazySingleton(
        () => SupabaseClient(Secrets.supabaseUrl, Secrets.supabaseAnnonKey));
    sl.registerLazySingleton(() => RoomsRepoImpl(sl()));
  }
}
