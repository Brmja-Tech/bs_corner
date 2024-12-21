import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';
import 'package:pscorner/features/rooms/presentation/widgets/add_extra_items/view_all_extras.dart';
import 'package:pscorner/service_locator/service_locator.dart';

void showExtraRequestsDialog(
  BuildContext context, {
  required int roomId,
  required String deviceType,
  required List<Map<String, dynamic>> restaurantItems,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return BlocProvider.value(
        value: sl<RestaurantsBloc>(),
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          content: SizedBox(
            width: context.width * 0.7,
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.purple,
                    )),
                const Expanded(flex: 5, child: ViewAllExtras()),
              ],
            ),
          ),
        ),
      );
    },
  );
}
