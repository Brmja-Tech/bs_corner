
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/flexible_image.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/features/recipes/presentation/blocs/recipes_cubit.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_state.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_cubit.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_state.dart';

class AddExtraQuantity extends StatelessWidget {
  final String roomId;
  final String deviceType;

  const AddExtraQuantity(
      {super.key, required this.roomId, required this.deviceType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              textDirection: TextDirection.ltr,
              children: [
                AppGaps.gap28Horizontal,
                Label(
                  text: deviceType,
                  color: Colors.black,
                ),
              ],
            ),
            AppGaps.gap8Vertical,
            Row(
              // textDirection: TextDirection.ltr,
              children: [
                const Label(
                  text: 'السعر',
                  color: Colors.black,
                ),
                AppGaps.gap28Horizontal,
                const Label(
                  text: 'الكميه',
                  color: Colors.black,
                ),
                const Spacer(),
                const Label(
                  text: 'الاسم',
                  color: Colors.black,
                ),
              ],
            ),
            const Divider(),
            BlocBuilder<RoomsBloc, RoomsState>(
              builder: (room, state) {
                return BlocBuilder<RestaurantsBloc, RestaurantsState>(
                  builder: (context, state) {
                    return Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          ListView.separated(
                            itemCount: state.selectedItems.length,
                            padding: const EdgeInsets.only(bottom: 150),
                            separatorBuilder: (context, index) => const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            itemBuilder: (context, index) {
                              final item = state.selectedItems[index];
                              return Row(
                                // textDirection: TextDirection.ltr,
                                children: [
                                  Label(
                                    text: item.price.toString(),
                                    color: Colors.black,
                                  ),
                                  AppGaps.gap28Horizontal,
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.add),
                                            onPressed: () {
                                              final currentQuantity = state
                                                  .quantity
                                                  .firstWhere(
                                                      (e) => e.id == item.id,
                                                      orElse: () =>
                                                          ItemQuantity(
                                                              id: item.id,
                                                              quantity: 0,
                                                              price:
                                                                  item.price))
                                                  .quantity;

                                              context
                                                  .read<RestaurantsBloc>()
                                                  .setQuantity(
                                                    id: item.id,
                                                    quantity:
                                                        currentQuantity + 1,
                                                    price: item.price,
                                                  );
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.remove),
                                            onPressed: () {
                                              final currentQuantity = state
                                                  .quantity
                                                  .firstWhere(
                                                      (e) => e.id == item.id,
                                                      orElse: () =>
                                                          ItemQuantity(
                                                              id: item.id,
                                                              quantity: 0,
                                                              price:
                                                                  item.price))
                                                  .quantity;

                                              if (currentQuantity > 0) {
                                                context
                                                    .read<RestaurantsBloc>()
                                                    .setQuantity(
                                                      id: item.id,
                                                      quantity:
                                                          currentQuantity - 1,
                                                      price: item.price,
                                                    );
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      Label(
                                        text: state.quantity
                                            .firstWhere((e) => e.id == item.id,
                                                orElse: () => ItemQuantity(
                                                    id: item.id,
                                                    quantity: 0,
                                                    price: item.price))
                                            .quantity
                                            .toString(),
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Label(
                                    text: item.name,
                                    fontWeight: FontWeight.bold,
                                    // fontSize: 20,
                                    maxLines: 5,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    selectable: false,
                                  ),

                                  AppGaps.gap8Horizontal,
                                  if (context.width > 1200)
                                    FlexibleImage(imagePathOrData: item.imagePath,isCircular: true,width: 60,height: 60,)
                                ],
                              );
                            },
                          ),
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.9),
                                  blurRadius: 3,
                                  spreadRadius: 5,
                                  offset: const Offset(1, 1),
                                ),
                              ],
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(10)),
                            ),
                            child: Column(
                              children: [
                                AppGaps.gap8Vertical,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Label(
                                      text: 'الاجمالي',
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    AppGaps.gap28Horizontal,
                                    Label(
                                      text:
                                          '${context.read<RestaurantsBloc>().calculateTotalPrice().toString()} جنيه',
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  child: CustomButton(
                                      alignment: Alignment.center,
                                      text: 'إضافه الي الروم',
                                      width: double.infinity / 2,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20),
                                      onPressed: () {
                                        
                                        insertConsumption(context);
                                      }),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void insertConsumption(BuildContext context) {
    try{
      
    
    context
        .read<RoomsBloc>()
        .insertRoomConsumption(
          context: context,
          quantity: context
              .read<RestaurantsBloc>()
              .state
              .quantity,
          roomId: roomId,
        );
    context.read<RecipesBloc>().updateRecipe(id: id);
  }catch(e){
    loggerError(e);
    }
    }
}
