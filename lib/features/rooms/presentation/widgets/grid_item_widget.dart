import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/features/facilities/presentation/blocs/facilities_cubit.dart';
import 'package:pscorner/features/facilities/presentation/blocs/facilities_state.dart';
import 'package:pscorner/features/home/presentation/widgets/home_widget.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_cubit.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_state.dart';
import 'package:pscorner/features/rooms/presentation/widgets/add_extra_items/add_extra_food_items_dialogue.dart';
import 'package:pscorner/features/rooms/presentation/widgets/counter_widget.dart';
import 'package:pscorner/features/timers/presentation/blocs/timers_cubit.dart';
import 'package:pscorner/features/timers/presentation/blocs/timers_state.dart';

class GridItemWidget extends StatefulWidget {
  final num price;
  final String id;
  final String deviceType;
  final String state;
  final bool openTime;
  bool isMultiplayer;
  final String initialTime;
  final String initialMultiTime;

  GridItemWidget({
    super.key,
    required this.id,
    required this.deviceType,
    required this.state,
    required this.openTime,
    required this.isMultiplayer,
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
    return BlocConsumer<TimersCubit, TimersState>(
      listener: (context, state) {
        if (state is TimerFailure) {
          context.showErrorMessage('يوجد مشكلة في بدأ الغرفة');
        } else if (state is TimerSuccess) {
          context.showSuccessMessage(state.message);
        }
      },
      builder: (context, state) {
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
                if (state is TimersLoading) const LinearProgressIndicator(),
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
                        style: const TextStyle(
                            fontSize: 20, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (widget.state == 'not running')
                  Image.asset(
                    'assets/images/playstation.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                const Spacer(),
                if (widget.state == 'pre-booked') ...[
                  const Text(
                    'غرفه محجوزه',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<RoomsBloc>().updateItem(
                            id: widget.id,
                            roomState: 'running',
                            multTime: "00:00:00",
                            time: '00:00:00');
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
                // State-based display
                if (widget.state != 'pre-booked' &&
                    widget.state != 'not running') ...[
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
                              restaurantItems: context
                                  .read<RestaurantsBloc>()
                                  .state
                                  .restaurants,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(241, 217, 138, 1),
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
                          if (widget.isMultiplayer) {
                            loggerWarn('updating regular time $duration');
                            context
                                .read<RoomsBloc>()
                                .updateItem(id: widget.id, multTime: duration);
                          } else {
                            loggerWarn('updating Multi time $duration');

                            context
                                .read<RoomsBloc>()
                                .updateItem(id: widget.id, time: duration);
                          }
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
                          if (widget.state == 'paused')
                            RoomActionWidget(
                              onTap: () {
                                setState(() {
                                  isPaused = false;
                                });
                                context.read<RoomsBloc>().updateItem(
                                    id: widget.id, roomState: 'running');
                              },
                              icon: Icons.play_arrow,
                              backgroundColor:
                                  const Color.fromRGBO(76, 106, 242, 1),
                              text: 'استمرار',
                            ),
                          if (widget.state == 'running')
                            RoomActionWidget(
                              onTap: () {
                                setState(() {
                                  isPaused = true;
                                });
                                context.read<RoomsBloc>().updateItem(
                                    id: widget.id, roomState: 'paused');
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
                                  .updateItem(
                                      id: widget.id,
                                      roomState: 'not running',
                                      time: '00:00:00',
                                      multTime: '00:00:00')
                                  .then((value) {
                                final roomConsumptions = context
                                    .read<RoomsBloc>()
                                    .state
                                    .roomConsumptions
                                    .where((consumption) =>
                                        consumption['room_id'] == widget.id)
                                    .toList();

                                // Loop through and delete each consumption
                                for (var consumption in roomConsumptions) {
                                  context
                                      .read<RoomsBloc>()
                                      .deleteRoomConsumption(
                                          id: consumption['id']);
                                }
                              });
                            },
                            icon: Icons.stop_circle_outlined,
                            backgroundColor:
                                const Color.fromRGBO(224, 35, 41, 1),
                            text: 'ايقاف',
                          ),
                          RoomActionWidget(
                            onTap: () {
                              _showAvailableRooms(
                                context,
                                isMultiplayer: widget.isMultiplayer,
                                openTime: widget.openTime,
                                deviceType: widget.deviceType,
                                id: widget.id,
                                state: widget.state,
                                price: widget.price,
                                elapsedTime:
                                    !widget.isMultiplayer ? _elapsedTime : null,
                                elapsedMultiTime:
                                    widget.isMultiplayer ? _elapsedTime : null,
                              );
                            },
                            icon: Icons.loop,
                            backgroundColor:
                                const Color.fromRGBO(88, 166, 156, 1),
                            text: 'تغير\n جهاز ',
                          ),
                          BlocListener<RoomsBloc, RoomsState>(
                            listener: (context, state) {
                              if (state.isSuccess) {
                                // Find the room that matches the current widget.id
                                final currentRoom = state.rooms.firstWhere(
                                  (room) => room.id == widget.id.toString(),
                                );
                              }
                            },
                            child: RoomActionWidget(
                              onTap: () {
                                context.read<RoomsBloc>().updateItem(
                                    id: widget.id,
                                    multTime: widget.isMultiplayer
                                        ? _elapsedTime
                                        : null,
                                    time: !widget.isMultiplayer
                                        ? _elapsedTime
                                        : null,
                                    isMultiplayer: !widget.isMultiplayer);
                                setState(() {
                                  widget.isMultiplayer = !widget.isMultiplayer;
                                });
                              },
                              icon: Icons.swap_horiz,
                              backgroundColor:
                                  const Color.fromRGBO(154, 147, 179, 1),
                              text: widget.isMultiplayer
                                  ? 'مالتي الى\n سنجل'
                                  : 'سنجل الى\n مالتي',
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ] else if (widget.state == 'not running') ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ElevatedButton(
                          onPressed: () => context.read<RoomsBloc>().updateItem(
                              id: widget.id, roomState: 'pre-booked'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(241, 217, 138, 1),
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
                                .read<TimersCubit>()
                                .startTimer(roomId: widget.id);
                            // context.read<RoomsBloc>().updateItem(
                            //       id: widget.id,
                            //       roomState: 'running',
                            //       time: '00:00:00',
                            //       multTime: '00:00:00',
                            //     );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(44, 102, 153, 1),
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
      },
    );
  }

  String? selectedRoomId;

  void _showAvailableRooms(
    BuildContext context, {
    required String id,
    required String deviceType,
    required String state,
    required bool openTime,
    required bool isMultiplayer,
    required num price,
    required String? elapsedTime,
    required String? elapsedMultiTime,
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
                            context.read<RoomsBloc>().transferRoomData(
                                sourceId: id,
                                targetId: value!,
                                targetState: state,
                                targetIsMultiplayer: isMultiplayer,
                                targetOpenTime: openTime,
                                targetPrice: price,
                                targetElapsedTime: elapsedTime,
                                targetElapsedMultiTime: elapsedMultiTime);
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
