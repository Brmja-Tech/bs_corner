import 'package:flutter/material.dart';
import 'package:pscorner/core/stateless/custom_scaffold.dart';

class ShiftsScreen extends StatelessWidget {
  const ShiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      body: Text('Shifts Screen'),
      selectedIndex: 2,
    );
  }
}
