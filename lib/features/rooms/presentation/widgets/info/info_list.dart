import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_cubit.dart';

import '../../blocs/rooms_state.dart';

class InfoList extends StatefulWidget {
  final int id;

  const InfoList({super.key, required this.id});

  @override
  State<InfoList> createState() => _InfoListState();
}

class _InfoListState extends State<InfoList> {
  @override
  void initState() {
    context.read<RoomsBloc>().fetchRoomConsumptions(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomsBloc, RoomsState>(
      builder: (context, state) {
        return Container(
          constraints:
              const BoxConstraints(minHeight: 300, minWidth: double.infinity),
          color: Colors.white,
          child: state.roomConsumptions.isEmpty
              ? const Center(child: Label(text: 'لا يوجد'))
              : ListView.builder(
                  itemCount: state.roomConsumptions.length,
                  itemBuilder: (context, index) {
                    var restaurantBloc = context.read<RestaurantsBloc>();
                    var restaurantImage = restaurantBloc.state.restaurants[state
                        .roomConsumptions[index]['restaurant_id']]['image'];

                    loggerWarn(restaurantBloc.state.restaurants);
                    return Column(
                      children: [
                        ListTile(
                          trailing: CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  FileImage(File(restaurantImage))),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${state.roomConsumptions[index]['name']}'),
                              Text(
                                '${state.roomConsumptions[index]['price'].toString()} جنيه',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            ' الكمية: ${state.roomConsumptions[index]['quantity'].toString()} ',
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Divider(
                          color: Color(0xffEBD6D6),
                        )
                      ],
                    );
                  },
                ),
        );
      },
    );
  }
}
