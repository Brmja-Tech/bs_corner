import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/custom_scaffold.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/core/theme/text_theme.dart';
import 'package:pscorner/features/restaurants/presentation/blocs/restaurants_cubit.dart';
import 'package:pscorner/features/restaurants/presentation/views/add_item_screen.dart';
import 'package:pscorner/service_locator/service_locator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> gridItems = [
      {
        'title': 'Room "5"',
        'subtitle': 'محجوز مسبقًا',
        'icon': Icons.play_arrow,
        'buttonLabel': 'ابدأ الآن'
      },
      {
        'title': 'Room "4"',
        'subtitle': 'PS4/Single',
        'icon': Icons.timer,
        'time': '02:56:12',
        'buttonLabel': 'طلبات إضافية'
      },
      {
        'title': 'Room "10"',
        'subtitle': 'Available',
        'icon': Icons.videogame_asset,
        'buttonLabel': 'ابدأ الآن'
      },
      {
        'title': 'Room "5"',
        'subtitle': 'محجوز مسبقًا',
        'icon': Icons.play_arrow,
        'buttonLabel': 'ابدأ الآن'
      },
      {
        'title': 'Room "4"',
        'subtitle': 'PS4/Single',
        'icon': Icons.timer,
        'time': '02:56:12',
        'buttonLabel': 'طلبات إضافية'
      },
      {
        'title': 'Room "10"',
        'subtitle': 'Available',
        'icon': Icons.videogame_asset,
        'buttonLabel': 'ابدأ الآن'
      },
      {
        'title': 'Room "5"',
        'subtitle': 'محجوز مسبقًا',
        'icon': Icons.play_arrow,
        'buttonLabel': 'ابدأ الآن'
      },
      {
        'title': 'Room "4"',
        'subtitle': 'PS4/Single',
        'icon': Icons.timer,
        'time': '02:56:12',
        'buttonLabel': 'طلبات إضافية'
      },
      {
        'title': 'Room "10"',
        'subtitle': 'Available',
        'icon': Icons.videogame_asset,
        'buttonLabel': 'ابدأ الآن'
      },
      {
        'title': 'Room "5"',
        'subtitle': 'محجوز مسبقًا',
        'icon': Icons.play_arrow,
        'buttonLabel': 'ابدأ الآن'
      },
      {
        'title': 'Room "4"',
        'subtitle': 'PS4/Single',
        'icon': Icons.timer,
        'time': '02:56:12',
        'buttonLabel': 'طلبات إضافية'
      },
      {
        'title': 'Room "10"',
        'subtitle': 'Available',
        'icon': Icons.videogame_asset,
        'buttonLabel': 'ابدأ الآن'
      },
      // Add more items as needed
    ];
    return CustomScaffold(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
                CustomButton(
                  text: 'اضافه غرفه',
                  onPressed: () {},
                  width: context.width * 0.1,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                ),
              ],
            ),
            AppGaps.gap8Vertical,
            Expanded(
              child: GridView.builder(
                itemCount: gridItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 8.0,
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisExtent: 350,
                  childAspectRatio: 16 / 16,
                ),
                itemBuilder: (context, index) {
                  final item = gridItems[index];
                  return Stack(
                    children: [
                      GridItemWidget(
                        title: item['title'],
                        subtitle: item['subtitle'],
                        icon: item['icon'],
                        buttonLabel: item['buttonLabel'],
                        time: item['time'],
                      ),
                      if (item['time'] != null)
                        Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.info_outline,
                                  color: Color.fromRGBO(44, 102, 153, 1),
                                  size: 30,
                                ))),
                    ],
                  );
                },
              ),
            ),
          ],
        ));
  }
}

class GridItemWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String buttonLabel;
  final String? time;

  const GridItemWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.buttonLabel,
    this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 400,
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  if (time != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      time!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Center(
                    child: Image.asset(
                      'assets/images/playstation.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Spacer(),
                  Align(
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {},
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(44, 102, 153, 1),
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              buttonLabel,
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
