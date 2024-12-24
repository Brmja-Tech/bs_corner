import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/custom_scaffold.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/features/employees/presentation/blocs/employees_cubit.dart';
import 'package:pscorner/features/employees/presentation/blocs/employees_state.dart';
import 'package:pscorner/features/employees/presentation/widgets/add_employee_dialog.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      selectedIndex: 3,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppGaps.gap16Vertical,
          Label(
            text: 'جدول الموظفين',
            style: context.appTextTheme.displayLarge?.copyWith(fontSize: 25),
          ),
          BlocBuilder<EmployeesBloc, EmployeesState>(
            builder: (context, state) {
              return Expanded(
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text(
                        'اسم الموظف',
                        style: context.appTextTheme.headlineSmall,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'الوظيفه',
                        style: context.appTextTheme.headlineSmall,
                      ),
                    ),
                  ],
                  rows: state.employees.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(
                        item['username'] ?? '', // Access 'name' from the map
                        style: context.appTextTheme.headlineMedium,
                      )),
                      DataCell(Text(
                        item['isAdmin']==1 ? 'مدير' : 'موظف', // Access 'job' from the map
                        style: context.appTextTheme.headlineMedium,
                      )),
                    ]);
                  }).toList(),
                ),
              );
            },
          ),
          CustomButton(
              text: 'إضافه موظف',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const AddEmployeeDialog(),
                );
              }),
        ],
      ),
    );
  }
}
