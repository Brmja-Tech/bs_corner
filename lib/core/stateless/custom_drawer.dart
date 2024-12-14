import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/features/accounts/presentation/views/accounts_screen.dart';
import 'package:pscorner/features/employees/presentation/views/employees_screen.dart';
import 'package:pscorner/features/home/presentation/views/home_screen.dart';
import 'package:pscorner/features/reports/presentation/blocs/reports_cubit.dart';
import 'package:pscorner/features/reports/presentation/views/reports_screen.dart';
import 'package:pscorner/features/shifts/presentation/views/shifts_screen.dart';
import 'package:pscorner/service_locator/service_locator.dart';

class CustomDrawer extends StatelessWidget {
  final int selectedIndex;

  const CustomDrawer({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> drawerItems = [
      {
        'icon': Icons.home,
        'label': 'الصفحة الرئيسية',
        'widget': BlocProvider(
            create: (context) => sl<ReportsBloc>(), child: const HomeScreen())
      },
      {
        'icon': Icons.bar_chart,
        'label': 'تقارير',
        'widget': const ReportsScreen()
      },
      {
        'icon': Icons.shopping_bag_rounded,
        'label': 'الشيفتات',
        'widget': const ShiftsScreen()
      },
      {
        'icon': Icons.people,
        'label': 'الموظفين',
        'widget': const EmployeesScreen()
      },
      {
        'icon': Icons.analytics,
        'label': 'الحسابات',
        'widget': const AccountsScreen()
      },
    ];
    return Drawer(
      width: context.width * 0.2,
      child: SizedBox(
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Drawer Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: const Text(
                'القائمة',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Drawer Items
            Expanded(
              child: ListView.builder(
                itemCount: drawerItems.length,
                itemBuilder: (context, index) {
                  final item = drawerItems[index];
                  return InkWell(
                    onTap: () {
                      if (selectedIndex == index) return;

                      context.goWithNoReturn(item['widget']);
                    },
                    child: Container(
                      color: selectedIndex == index
                          ? Colors.blue.shade50
                          : Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            item['icon'],
                            color: selectedIndex == index
                                ? Colors.blue
                                : Colors.grey.shade700,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item['label'],
                              style: TextStyle(
                                fontSize: 16,
                                color: selectedIndex == index
                                    ? Colors.blue
                                    : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
