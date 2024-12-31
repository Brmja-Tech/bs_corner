import 'package:get_it/get_it.dart';
import 'package:pscorner/service_locator/auth_local_service_locator.dart';
import 'package:pscorner/service_locator/data_base_service_locator.dart';
import 'package:pscorner/service_locator/empolyee_service_locator.dart';
import 'package:pscorner/service_locator/facilities_service_locator.dart';
import 'package:pscorner/service_locator/recipes_service_locator.dart';
import 'package:pscorner/service_locator/report_service_locator.dart';
import 'package:pscorner/service_locator/restraurants_service_locator.dart';
import 'package:pscorner/service_locator/rooms_repo_impl.dart';
import 'package:pscorner/service_locator/rooms_service_locator.dart';
import 'package:pscorner/service_locator/shift_service_locator.dart';
import 'package:pscorner/service_locator/supabase_service_locator.dart';
import 'package:pscorner/service_locator/timer_service_locator.dart';

final sl = GetIt.instance;

abstract interface class DI {
  static Future<void> init() async {
    await DatabaseServiceLocator.execute(sl: sl);
    await SupabaseServiceLocator.execute(sl: sl);
    await AuthLocalServiceLocator.execute(sl: sl);
    await ReportServiceLocator.execute(sl: sl);
    await RestaurantsServiceLocator.execute(sl: sl);
    await RoomsServiceLocator.execute(sl: sl);
    await EmployeeServiceLocator.execute(sl: sl);
    await ShiftServiceLocator.execute(sl: sl);
    await RecipesServiceLocator.execute(sl: sl);
    await RoomsRepoImplServiceLocator.execute(sl: sl);
    await FacilitiesServiceLocator.execute(sl: sl);
    await TimerServiceLocator.execute(sl: sl);
  }
}
