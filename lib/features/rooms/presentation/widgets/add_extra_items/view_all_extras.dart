import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/theme/colors.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';
import 'package:pscorner/features/rooms/presentation/widgets/add_extra_items/grid_view_tab.dart';
// import 'package:pscorner/service_locator/service_locator.dart';

class ViewAllExtras extends StatelessWidget {
  const ViewAllExtras({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: const Text(
            'اختر الاضافات',
            style: TextStyle(color: Colors.black),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelStyle: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold),
            labelColor: Colors.black,
            dividerColor: AppColors.deepNavyBlue,
            overlayColor: WidgetStatePropertyAll(Colors.black12),
            indicator: BoxDecoration(color: Colors.transparent),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'مأكولات'),
              Tab(text: 'مشروبات'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GridViewTab(
                data: context
                    .read<RestaurantsBloc>()
                    .state
                    .restaurants
                    .where((restaurant) => restaurant['type'] == 'dish')
                    .toList()),
            GridViewTab(
                data: context
                    .read<RestaurantsBloc>()
                    .state
                    .restaurants
                    .where((restaurant) => restaurant['type'] == 'drink')
                    .toList()),
          ],
        ),
      ),
    );
  }
}
