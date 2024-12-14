import 'package:flutter/material.dart';
import 'package:pscorner/core/stateless/custom_scaffold.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomScaffold(
      selectedIndex: 4,
      body: Text('Accounts Screen'),
    );
  }
}
