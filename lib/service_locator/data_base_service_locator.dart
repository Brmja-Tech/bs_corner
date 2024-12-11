import 'package:get_it/get_it.dart';

import '../core/data/sql/sqlfilte_ffi_consumer.dart';

class DatabaseServiceLocator {
  static Future<void> execute({required GetIt sl}) async {
    sl.registerLazySingleton<SQLFLiteFFIConsumer>(
        () => SQLFLiteFFIConsumerImpl());
    await sl<SQLFLiteFFIConsumer>().initDatabase('PS Corner');
  }
}
