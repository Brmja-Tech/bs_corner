import 'package:flutter/material.dart';
import 'package:pscorner/core/stateless/custom_scaffold.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      selectedIndex: 3,
      body: Text('Employees Screen'),
    );
  }
}
