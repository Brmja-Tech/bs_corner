import 'package:get_it/get_it.dart';
import 'package:pscorner/core/data/supabase/supabase_consumer.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/secrets/secrets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static final SupabaseService instance = SupabaseService._();

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: Secrets.supabaseUrl,
      anonKey: Secrets.supabaseAnnonKey,
    );
    logger('Supabase initialized');
  }

  SupabaseClient get client => Supabase.instance.client;
}

class SupabaseServiceLocator {
  static Future<void> execute({required GetIt sl}) async {
    sl.registerLazySingleton<SupabaseService>(() => SupabaseService.instance);

    await SupabaseService.initialize();

    //
    sl.registerLazySingleton<SupabaseConsumer>(
        () => SupabaseConsumerImpl(sl<SupabaseService>().client));
  }
}
