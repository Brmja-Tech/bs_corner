import 'package:flutter/material.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/custom_scaffold.dart';

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
      // Add more items as needed
    ];
    return CustomScaffold(
        selectedIndex: 0,
        body: GridView.builder(
          itemCount: gridItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 items per row
            mainAxisSpacing: 8.0, // Spacing between rows
            crossAxisSpacing: 8.0, // Spacing between columns
            childAspectRatio: 1, // Adjust aspect ratio for the grid items
          ),
          itemBuilder: (context, index) {
            final item = gridItems[index];
            return GridItemWidget(
              title: item['title'],
              subtitle: item['subtitle'],
              icon: item['icon'],
              buttonLabel: item['buttonLabel'],
              time: item['time'],
            );
          },
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 200,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            Image.asset('assets/images/playstation.png'),
            if (time != null) ...[
              const SizedBox(height: 8),
              Text(
                time!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
            ],
            Spacer(),
            CustomButton(text: 'تأكيد',onPressed: (){},width: double.infinity,),
          ],
        ),
      ),
    );
  }
}
