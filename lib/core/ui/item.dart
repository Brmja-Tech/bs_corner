import 'package:flutter/material.dart';

class Item extends StatelessWidget {
  const Item({super.key, required this.name, required this.color});
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50, // Set a fixed width
      height: 50, // Set a fixed height
      child: Card(
        color: color,
        child: Center(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
