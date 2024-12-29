import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/custom_scaffold.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/core/theme/text_theme.dart';
import 'package:pscorner/core/ui/items_consumed_view.dart';
import 'package:pscorner/core/ui/items_grid.dart';
import 'package:pscorner/features/restaurants/presentation/views/add_item_screen.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_cubit.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_state.dart';
import 'package:pscorner/features/rooms/presentation/widgets/room_grid_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _deviceTypes = ['PS4', 'PS5', 'TV'];
  String? _selectedDeviceType;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        selectedIndex: 0,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Align(
                    alignment: AlignmentDirectional.topStart,
                    child: BlocBuilder<RoomsBloc, RoomsState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            // context.read<RoomsBloc>().clearRooms();
                          },
                          child: Label(
                            text: 'الاجهزة المتاحة ',
                            selectable: false,
                            style: AppTextTheme.titleLarge,
                          ),
                        );
                      },
                    )),
                Expanded(child: Container()),
                CustomButton(
                  text: 'اضافه وجبات',
                  onPressed: () {
                    context.go(const AddItemScreen());
                  },
                  width: context.width * 0.1,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
                BlocBuilder<RoomsBloc, RoomsState>(
                  builder: (context, state) {
                    return CustomButton(
                      text: 'اضافه غرفه',
                      onPressed: () {
                        _showAddRoomDialog(context, context.read<RoomsBloc>());
                      },
                      width: context.width * 0.1,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                    );
                  },
                ),
              ],
            ),
            AppGaps.gap8Vertical,
            Expanded(
              child: BlocBuilder<RoomsBloc, RoomsState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      if (state.isLoading) const LinearProgressIndicator(),
                      Expanded(
                        child: Row(
                          children: [
                            // Rooms Section
                            Expanded(
                              flex: 4,
                              child: state.rooms.isEmpty
                                  ? const Center(
                                      child: Text('لا يوجد غرف'),
                                    )
                                  : RoomGridBuilder(state: state),
                            ),
                            // Items Consumed Section
                            const Flexible(
                              child: ItemsConsumedView(),
                            ),
                          ],
                        ),
                      ),
                      // ItemsGrid Section
                      const Expanded(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: ItemsGrid(),
                            ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ));
  }

  void _showAddRoomDialog(BuildContext context, RoomsBloc cubit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          actionsPadding: const EdgeInsets.all(20),
          title: const Text('اضافه غرفه'),
          content: BlocListener<RoomsBloc, RoomsState>(
            listener: (context, state) {
              if (state.isSuccess) {
                context.showSuccessMessage('تمت عمليه اضافه غرفه');
              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'نوع الجهاز',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedDeviceType,
                  items: _deviceTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDeviceType = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              style: context.theme.elevatedButtonTheme.style!.copyWith(
                backgroundColor: WidgetStateProperty.all(
                  Colors.red,
                ),
                padding: WidgetStateProperty.all(const EdgeInsets.all(15)),
              ),
              child: const Text(
                'رجوع',
                style: TextStyle(fontSize: 15),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // var cubit = context.read<RoomsBloc>();
                _confirmRoomDetails(cubit);
              },
              style: context.theme.elevatedButtonTheme.style!.copyWith(
                padding: WidgetStateProperty.all(const EdgeInsets.all(15)),
              ),
              child: const Text(
                'تاكيد',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmRoomDetails(RoomsBloc cubit) {
    if (_selectedDeviceType == null) {
      // Show error if fields are empty
      context.showErrorMessage('اختر نوع الجهاز');
    } else {
      // Process the selected data here
      logger('Device Type: $_selectedDeviceType');

      // Close the dialog
      cubit.insertItem(deviceType: _selectedDeviceType!);

      // Optional: Show confirmation
      context.pop();
    }
  }
}
