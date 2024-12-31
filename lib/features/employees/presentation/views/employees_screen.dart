import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/custom_scaffold.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/core/ui/table_widget.dart';
import 'package:pscorner/features/employees/presentation/blocs/employees_cubit.dart';
import 'package:pscorner/features/employees/presentation/blocs/employees_state.dart';
import 'package:pscorner/features/employees/presentation/widgets/add_employee_dialog.dart';
import 'package:pscorner/features/employees/presentation/widgets/update_employee_dialogue.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    List<DataColumn> columns = [
      DataColumn(
        label: Flexible(
          child: Label(
            text: 'اسم الموظف',
            style: context.appTextTheme.headlineSmall,
          ),
        ),
      ),
      DataColumn(
        label: Label(
          text: 'الوظيفه',
          style: context.appTextTheme.headlineSmall,
        ),
      ),
      DataColumn(
        label: Label(
          text: 'الاجراءات',
          style: context.appTextTheme.headlineSmall,
        ),
      ),
    ];

    return CustomScaffold(
      selectedIndex: 3,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppGaps.gap16Vertical,
              Label(
                text: 'جدول الموظفين',
                style:
                    context.appTextTheme.displayLarge?.copyWith(fontSize: 25),
              ),
              AppGaps.gap48Vertical,
              BlocBuilder<EmployeesBloc, EmployeesState>(
                  builder: (context, state) {
                if (state.isLoading) {
                  return const LinearProgressIndicator();
                }
                return Container();
              }),
              BlocBuilder<EmployeesBloc, EmployeesState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: SizedBox(
                      height: mediaQuery.size.height * 0.6,
                      width: double.infinity,
                      child: TableWidget(
                        columns: columns,
                        rows: state.employees.map((item) {
                          return DataRow(cells: [
                            DataCell(Label(
                              text: item.username, // Access 'name' from the map
                              style: context.appTextTheme.headlineMedium,
                            )),
                            DataCell(Label(
                              text: item.role, // Access 'job' from the map
                              style: context.appTextTheme.headlineMedium,
                            )),
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButton(
                                      text: 'تعديل',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              UpdateEmployeeDialogue(
                                            id: item.id.toString(),
                                            role: item.role,
                                          ),
                                        );
                                      }),
                                  CustomButton(
                                      text: 'ازاله',
                                      color: context.theme.colorScheme.error,
                                      onPressed: () {
                                        context
                                            .read<EmployeesBloc>()
                                            .deleteEmployee(
                                                id: item.id);
                                      }),
                                ],
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 0),
                      child: CustomButton(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 20),
                          text: 'إضافه موظف',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const AddEmployeeDialog(),
                            );
                          }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
