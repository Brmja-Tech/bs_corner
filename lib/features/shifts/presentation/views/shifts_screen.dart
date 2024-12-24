import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/custom_scaffold.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/core/stateless/table_widget.dart';
import 'package:pscorner/features/shifts/presentation/blocs/shifts_cubit.dart';
import 'package:pscorner/features/shifts/presentation/blocs/shifts_state.dart';
import 'package:pscorner/features/shifts/presentation/widgets/add_shift_dialogue.dart';

class ShiftsScreen extends StatelessWidget {
  const ShiftsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      selectedIndex: 2,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppGaps.gap16Vertical,
          Align(
            alignment: AlignmentDirectional.topStart,
            child: Label(
              text: 'جدول الشيفتات',
              style: context.appTextTheme.displayLarge?.copyWith(fontSize: 25),
            ),
          ),
          AppGaps.gap48Vertical,
          BlocBuilder<ShiftsBloc, ShiftsState>(
            builder: (context, state) {
              if (state.isLoading)
                return const Center(
                  child: CircularProgressIndicator(),
                );
              return Expanded(
                child: TableWidget(
                  columns: [
                    DataColumn(
                      label: Text(
                        'اسم الموظف',
                        style: context.appTextTheme.headlineSmall,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'مدة البداية',
                        style: context.appTextTheme.headlineSmall,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'مدة النهاية',
                        style: context.appTextTheme.headlineSmall,
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'تفاصيل',
                        style: context.appTextTheme.headlineSmall,
                      ),
                    ),
                  ],
                  rows: state.shifts.map((item) {
                    return DataRow(cells: [
                      DataCell(Text(
                        item['shift_user_name'] ?? '',
                        // Access 'name' from the map
                        style: context.appTextTheme.headlineMedium,
                      )),
                      DataCell(Text(
                        item['from_time'],
                        style: context.appTextTheme.headlineMedium,
                      )),
                      DataCell(Text(
                        item['to_time'] ?? '',
                        style: context.appTextTheme.headlineMedium,
                      )),
                      DataCell(CustomButton(text: 'عرض', onPressed: () {})),
                    ]);
                  }).toList(),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 30),
            child: CustomButton(
                width: double.infinity,
                text: 'إضافه شيفت',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => const AddShiftDialog(),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
