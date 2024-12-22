import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      builder: (context,state){
        return Container(
          color: Colors.white,
          child: ListView.builder(
            itemCount: state.roomConsumptions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(state.roomConsumptions[index]['price'].toString()),
                subtitle: Text(state.roomConsumptions[index]['quantity'].toString()),
              );
            },
          ),
        );
      },
    );
  }
}
