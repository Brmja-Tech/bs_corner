import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/features/home/presentation/widgets/home_widget.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_cubit.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_state.dart';
import 'package:pscorner/features/rooms/presentation/widgets/add_extra_items/add_extra_food_items_dialogue.dart';
import 'package:pscorner/features/rooms/presentation/widgets/counter_widget.dart';

class GridItemWidget extends StatefulWidget {
  final num price;
  final String id;
  final String deviceType;
  final bool state;
  final bool openTime;
  final String initialTime;
  final String initialMultiTime;

  const GridItemWidget({
    super.key,
    required this.id,
    required this.deviceType,
    required this.state,
    required this.openTime,
    required this.price,
    required this.initialTime,
    required this.initialMultiTime,
  });

  @override
  State<GridItemWidget> createState() => _GridItemWidgetState();
}

class _GridItemWidgetState extends State<GridItemWidget> {
  late String _elapsedTime;

  @override
  void initState() {
    _elapsedTime = widget.initialTime;

    isPaused = widget.state == 'paused';
    super.initState();
  }

  late bool isPaused;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: context.width * 0.3,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Room ${widget.id}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 25),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Device: ${widget.deviceType}',
                    style: const TextStyle(fontSize: 20, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const Spacer(),
            if (!widget.state)
              Image.asset(
                'assets/images/playstation.png',
                width: 100,
                height: 100,
                fit: BoxFit.contain,
              ),
            const Spacer(),
            // if (!widget.state) ...[
            //   const Text(
            //     'غرفه محجوزه',
            //     style:
            //         TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            //   ),
            //   const SizedBox(height: 8),
            //   Padding(
            //     padding: const EdgeInsets.only(bottom: 8.0),
            //     child: ElevatedButton(
            //       onPressed: () {
            //         context.read<RoomsBloc>().updateItem(
            //               id: widget.id,
            //               isActive: true,
            //             );
            //       },
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: const Color.fromRGBO(44, 102, 153, 1),
            //       ),
            //       child: const Text(
            //         'ابدأ الان',
            //         style: TextStyle(color: Colors.white, fontSize: 16),
            //       ),
            //     ),
            //   ),
            // ],
            // State-based display
            if (widget.state) ...[
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        // logger(context.read<RestaurantsBloc>().state.restaurants);
                        showExtraRequestsDialog(
                          context,
                          deviceType: widget.deviceType,
                          roomId: widget.id,
                          restaurantItems:
                              context.read<RestaurantsBloc>().state.restaurants,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(241, 217, 138, 1),
                      ),
                      child: const Text(
                        'طلبات إضافيه',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  AppGaps.gap16Vertical,
                  CounterWidget(
                    initialTime: _elapsedTime,
                    onDatabaseUpdate: (duration) {
                      if (isPaused) return;
                      // loggerWarn('Multi player ${widget.isMultiplayer}');

                      // loggerWarn('updating Multi time $duration');

                      context.read<RoomsBloc>().updateItem(
                            id: widget.id,
                          );
                    },
                    onElapsedTimeUpdate: (duration) {
                      // logger(isPaused);
                      if (isPaused) return;
                      setState(() {
                        _elapsedTime = duration;
                      });
                    },
                    isPaused: isPaused,
                  ),
                  AppGaps.gap16Vertical,
                  Row(
                    textDirection: TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!widget.state)
                        RoomActionWidget(
                          onTap: () {
                            setState(() {
                              isPaused = false;
                            });
                            context
                                .read<RoomsBloc>()
                                .updateItem(id: widget.id, isActive: false);
                          },
                          icon: Icons.play_arrow,
                          backgroundColor:
                              const Color.fromRGBO(76, 106, 242, 1),
                          text: 'استمرار',
                        ),
                      if (widget.state)
                        RoomActionWidget(
                          onTap: () {
                            setState(() {
                              isPaused = true;
                            });
                            context
                                .read<RoomsBloc>()
                                .updateItem(id: widget.id, isActive: false);
                          },
                          icon: Icons.pause,
                          backgroundColor:
                              const Color.fromRGBO(241, 213, 129, 1),
                          text: 'ايقاف\n مؤقت',
                        ),
                      RoomActionWidget(
                        onTap: () {
                          setState(() {
                            _elapsedTime = '00:00:00';
                          });
                          context
                              .read<RoomsBloc>()
                              .updateItem(id: widget.id, isActive: false)
                              .then((value) {
                            final roomConsumptions = context
                                .read<RoomsBloc>()
                                .state
                                .roomConsumptions
                                .where((consumption) =>
                                    consumption['room_id'] == widget.id)
                                .toList();

                            // Loop through and delete each consumption
                            roomConsumptions.forEach((consumption) {
                              context
                                  .read<RoomsBloc>()
                                  .deleteRoomConsumption(id: consumption['id']);
                            });
                          });
                        },
                        icon: Icons.stop_circle_outlined,
                        backgroundColor: const Color.fromRGBO(224, 35, 41, 1),
                        text: 'ايقاف',
                      ),
                      RoomActionWidget(
                        onTap: () {
                          _showAvailableRooms(
                            context,
                            deviceType: widget.deviceType,
                            id: widget.id,
                            price: widget.price,
                          );
                        },
                        icon: Icons.loop,
                        backgroundColor: const Color.fromRGBO(88, 166, 156, 1),
                        text: 'تغير\n جهاز ',
                      ),
                      BlocListener<RoomsBloc, RoomsState>(
                        listener: (context, state) {
                          if (state.isSuccess) {
                            // Find the room that matches the current widget.id
                            state.rooms.firstWhere(
                              (room) => room.id == widget.id.toString(),
                            );
                          }
                        },
                        child: RoomActionWidget(
                          onTap: () {
                            context.read<RoomsBloc>().updateItem(
                                  id: widget.id,
                                );
                          },
                          icon: Icons.swap_horiz,
                          backgroundColor:
                              const Color.fromRGBO(154, 147, 179, 1),
                          text: false ? 'مالتي الى\n سنجل' : 'سنجل الى\n مالتي',
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ] else if (!widget.state) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () => context
                          .read<RoomsBloc>()
                          .updateItem(id: widget.id, isActive: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(241, 217, 138, 1),
                      ),
                      child: const Text(
                        'حجز مسبقا',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  AppGaps.gap28Horizontal,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        context
                            .read<RoomsBloc>()
                            .updateItem(id: widget.id, isActive: true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(44, 102, 153, 1),
                      ),
                      child: const Text(
                        'ابدأ الان',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // Image at the bottom
          ],
        ),
      ),
    );
  }

  String? selectedRoomId;

  void _showAvailableRooms(
    BuildContext context, {
    required String id,
    required String deviceType,
    required num price,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          actionsPadding: const EdgeInsets.all(20),
          title: const Text('اختر جهاز'),
          content: BlocListener<RoomsBloc, RoomsState>(
            listener: (context, state) {
              if (state.isSuccess) {
                context.showSuccessMessage('تمت عمليه التغير');
                context.pop();
              }
            },
            child: BlocBuilder<RoomsBloc, RoomsState>(
              builder: (context, rooms) {
                final availableRooms = context.read<RoomsBloc>().availableRooms;
                if (availableRooms.isEmpty) {
                  return const Center(
                      child: Text(
                          'لا توجد غرف متاحة')); // No available rooms message
                }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: availableRooms.map((room) {
                      return ListTile(
                        title: Text(
                          '${room.title}  ${room.id}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        leading: Radio<String>(
                          value: room.id,
                          // Use room ID as the value
                          groupValue: selectedRoomId,
                          onChanged: (String? value) {
                            setState(() {
                              selectedRoomId = value!;
                            });
                            // context.read<RoomsBloc>().transferRoomData(
                            //     sourceId: id,
                            //     targetId: value!,
                            //     targetState: state,
                            //     targetIsMultiplayer: isMultiplayer,
                            //     targetOpenTime: openTime,
                            //     targetPrice: price,
                            //     targetElapsedTime: elapsedTime,
                            //     targetElapsedMultiTime: elapsedMultiTime);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                if (selectedRoomId != null) {
                  // Handle the selected room ID if needed
                  // print('Selected Room ID: $selectedRoomId');
                }
              },
              child: const Text('إغلاق'),
            ),
          ],
        );
      },
    ).whenComplete(() {
      setState(() {
        selectedRoomId = null;
      });
    });
  }
}
