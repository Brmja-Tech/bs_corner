import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/stateless/label.dart';
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
  void didChangeDependencies() {
    context.read<RoomsBloc>().fetchRoomConsumptions(widget.id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomsBloc, RoomsState>(
      builder: (context, state) {
        if(state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Container(
          constraints:
          const BoxConstraints(minHeight: 300, minWidth: double.infinity),
          color: Colors.white,
          child: state.roomConsumptions.isEmpty
              ? const Center(child: Label(text: 'لا يوجد'))
              : ListView.builder(
            itemCount: state.roomConsumptions.length,
            itemBuilder: (context, index) {
              final item = state.roomConsumptions[index];
              // loggerWarn(restaurantBloc.state.restaurants);

              return Column(
                children: [
                  ListTile(
                    trailing: CircleAvatar(
                      radius: 30,
                      backgroundImage: FileImage(File(item['image'])), // Use null if no valid image
                      backgroundColor: Colors.grey[300], // Placeholder color
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w700),),
                        Text(
                          '${item['price'].toString()} جنيه',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      ' الكمية: ${item['quantity'].toString()} ',
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
