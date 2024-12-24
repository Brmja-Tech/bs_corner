import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/theme/app_theme.dart';
import 'package:pscorner/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:pscorner/features/auth/presentation/views/login_screen.dart';
import 'package:pscorner/features/employees/presentation/blocs/employees_cubit.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_cubit.dart';
import 'package:window_manager/window_manager.dart';

import 'service_locator/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(1024, 600),
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  await DI.init();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
    BlocProvider<RoomsBloc>(create: (context) => sl<RoomsBloc>()),
    BlocProvider<RestaurantsBloc>(create: (context) => sl<RestaurantsBloc>()),
    BlocProvider<EmployeesBloc>(create: (context) => sl<EmployeesBloc>()..fetchAllEmployees()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ps corner',
      theme: AppThemes.lightTheme(),
      locale: const Locale('ar'),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      routes: routes,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      home: const LoginScreen(),
    );
  }
}

final navigatorKey = GlobalKey<NavigatorState>();
