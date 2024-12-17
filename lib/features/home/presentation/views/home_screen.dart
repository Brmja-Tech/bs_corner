import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/custom_scaffold.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/core/theme/text_theme.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';
import 'package:pscorner/features/restaurants/presentation/views/add_item_screen.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_cubit.dart';
import 'package:pscorner/features/rooms/presentation/blocs/rooms_state.dart';
import 'package:pscorner/service_locator/service_locator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _deviceTypes = ['PS4', 'PS5'];
  String? _selectedDeviceType;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<RoomsBloc>()),
        BlocProvider.value(value: sl<RestaurantsBloc>()),
      ],
      child: CustomScaffold(
          selectedIndex: 0,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Label(
                        text: 'الاجهزة المتاحة ',
                        style: AppTextTheme.titleLarge,
                      )),
                  Expanded(child: Container()),
                  CustomButton(
                    text: 'اضافه وجبات',
                    onPressed: () {
                      context.go(BlocProvider.value(
                          value: sl<RestaurantsBloc>(),
                          child: const AddItemScreen()));
                    },
                    width: context.width * 0.1,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                  ),
                  BlocBuilder<RoomsBloc, RoomsState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'اضافه غرفه',
                        onPressed: () {
                          _showAddRoomDialog(
                              context, context.read<RoomsBloc>());
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
                        if (state.rooms.isEmpty)
                          const Expanded(
                            child: Center(
                              child: Text('لا يوجد غرف'),
                            ),
                          )
                        else
                          Expanded(
                            child: GridView.builder(
                              itemCount: state.rooms.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 8.0,
                                crossAxisCount: 4,
                                crossAxisSpacing: 8,
                                mainAxisExtent: 350,
                                childAspectRatio: 16 / 16,
                              ),
                              itemBuilder: (context, index) {
                                final item = state.rooms[index];
                                return Stack(
                                  children: [
                                    GridItemWidget(
                                      id: item['id'],
                                      openTime: item['open_time'] as int == 1
                                          ? true
                                          : false,
                                      state: item['state'],
                                      deviceType: item['device_type'],
                                      onStartNowPressed: () {
                                        logger(item['id']);
                                        context.read<RoomsBloc>().updateItem(
                                              id: item['id'],
                                              roomState: 'running',
                                            );
                                      },
                                    ),
                                    if (item['device_type'] != null)
                                      Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.info_outline,
                                                color: Color.fromRGBO(
                                                    44, 102, 153, 1),
                                                size: 30,
                                              ))),
                                  ],
                                );
                              },
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }

  void _showAddRoomDialog(BuildContext context, RoomsBloc cubit) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: sl<RoomsBloc>(),
          child: AlertDialog(
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
          ),
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

class GridItemWidget extends StatelessWidget {
  final int id;
  final String deviceType;
  final String state;
  final bool openTime;
  final VoidCallback? onStartNowPressed;

  const GridItemWidget({
    super.key,
    required this.id,
    required this.deviceType,
    required this.state,
    required this.openTime,
    this.onStartNowPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
            // Device Type and Room ID
            Padding(
              padding: const EdgeInsets.all(16.0).add(
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
              child: Column(
                children: [
                  Text(
                    'Room $id',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Device: $deviceType',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ),

            const Spacer(),
            Image.asset(
              'assets/images/playstation.png',
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
            const Spacer(),

            // State-based display
            if (state == 'running') ...[
              const Text(
                'يعمل الان ',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'وقت مفتوح: ${openTime ? "Yes" : "No"}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ] else if (state == 'not running') ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: ElevatedButton(
                  onPressed: onStartNowPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(44, 102, 153, 1),
                  ),
                  child: const Text(
                    'ابدأ الان',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],

            // Image at the bottom
          ],
        ),
      ),
    );
  }
}
