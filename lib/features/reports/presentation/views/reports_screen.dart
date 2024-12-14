import 'package:flutter/material.dart';
import 'package:pscorner/core/stateless/custom_scaffold.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      selectedIndex: 1,
      body: Column(
        children: [
          Text('Reports Screen'),
        ],
      ),
    );
  }
}
