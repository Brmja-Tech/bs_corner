import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/theme/colors.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_state.dart';
import 'package:pscorner/features/rooms/presentation/widgets/add_extra_items/grid_view_tab.dart';
// import 'package:pscorner/service_locator/service_locator.dart';

class ViewAllExtras extends StatefulWidget {
  const ViewAllExtras({super.key});

  @override
  State<ViewAllExtras> createState() => _ViewAllExtrasState();
}

class _ViewAllExtrasState extends State<ViewAllExtras> {
  @override
  Future<void> didChangeDependencies() async {
    // await context.read<RestaurantsBloc>().fetchAllItems();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // logger(context.read<RestaurantsBloc>().state.restaurants);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
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
        body: BlocBuilder<RestaurantsBloc, RestaurantsState>(
          builder: (context, state) {
           if(state.isLoading) return const Center(child: CircularProgressIndicator(),);

            return TabBarView(
              children: [
                GridViewTab(
                    data:state
                        .restaurants
                        .where((restaurant) => restaurant['type'] == 'dish')
                        .toList()),
                GridViewTab(
                    data:state
                        .restaurants
                        .where((restaurant) => restaurant['type'] == 'drink')
                        .toList()),
              ],
            );
          },
        ),
      ),
    );
  }
}
