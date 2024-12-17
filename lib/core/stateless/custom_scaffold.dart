import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/stateless/custom_app_bar.dart';
import 'package:pscorner/core/stateless/custom_drawer.dart';
import 'package:pscorner/core/stateless/responsive_scaffold.dart';
import 'package:pscorner/features/reports/presentation/blocs/reports_cubit.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';
import 'package:pscorner/service_locator/service_locator.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final int selectedIndex;

  const CustomScaffold(
      {super.key, required this.body, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
       BlocProvider(create: (context)=>  sl<RestaurantsBloc>()),
       BlocProvider(create: (context)=>  sl<ReportsBloc>()),
      ],
      child: ResponsiveScaffold(
        appBar: const CustomAppBar(),
        desktopBody: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomDrawer(selectedIndex: selectedIndex),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
