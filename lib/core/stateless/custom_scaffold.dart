import 'package:flutter/material.dart';
import 'package:pscorner/core/stateless/custom_app_bar.dart';
import 'package:pscorner/core/stateless/custom_drawer.dart';
import 'package:pscorner/core/stateless/responsive_scaffold.dart';

class CustomScaffold extends StatelessWidget {
  final Widget body;
  final int selectedIndex;

  const CustomScaffold(
      {super.key, required this.body, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: const CustomAppBar(),
      desktopBody: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomDrawer(selectedIndex: selectedIndex),
          Expanded(child: body),
        ],
      ),
    );
  }
}
