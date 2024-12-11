import 'package:get_it/get_it.dart';
import 'package:pscorner/service_locator/auth_local_service_locator.dart';
import 'package:pscorner/service_locator/data_base_service_locator.dart';
import 'package:pscorner/service_locator/report_service_locator.dart';

final sl = GetIt.instance;

abstract interface class DI {
  static Future<void> init() async {
    await DatabaseServiceLocator.execute(sl: sl);
    await AuthLocalServiceLocator.execute(sl: sl);
    await ReportServiceLocator.execute(sl: sl);
  }
}
