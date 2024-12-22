import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          color: Colors.white,
          child: state.roomConsumptions.isEmpty
              ? const Center(child: Label(text: 'لا يوجد'))
              : ListView.builder(
                  itemCount: state.roomConsumptions.length,
                  itemBuilder: (context, index) {
                    var restaurantBloc = context.read<RestaurantsBloc>();
                    var restaurantImage = restaurantBloc.state.restaurants[state
                        .roomConsumptions[index]['restaurant_id']]['image'];

                    // loggerWarn(restaurantBloc.state.restaurants);
                    return ListTile(
                      trailing: CircleAvatar(
                          backgroundImage: FileImage(File(restaurantImage))),
                      title: Text(
                          state.roomConsumptions[index]['price'].toString()),
                      subtitle: Text(
                          state.roomConsumptions[index]['quantity'].toString()),
                    );
                  },
                ),
        );
      },
    );
  }
}
