import 'package:flutter/material.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_state.dart';
import 'package:pscorner/features/rooms/presentation/widgets/grid_item_widget.dart';

class GridBuilder extends StatelessWidget {
  final RoomsState state;

  const GridBuilder({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: state.rooms.length,
        padding: const EdgeInsets.only(bottom: 30),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 8.0,
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisExtent: 400,
        ),
        itemBuilder: (context, index) {
          final item = state.rooms[index];
          return Stack(
            children: [
              GridItemWidget(
                price: item['price'],
                isMultiplayer: item['is_multiplayer'] == 1 ? true : false,
                id: item['id'],
                openTime: item['open_time'] as int == 1 ? true : false,
                state: item['state'],
                deviceType: item['device_type'],
                initialTime: item['time']??'00:00:00',
              ),
              Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                      onPressed: () {
                        // context.read<RoomsBloc>().updateItem(id: item['id'],roomState: 'not running');
                      },
                      icon: const Icon(
                        Icons.info_outline,
                        color: Color.fromRGBO(44, 102, 153, 1),
                        size: 30,
                      ))),
            ],
          );
        },
      ),
    );
  }
}
