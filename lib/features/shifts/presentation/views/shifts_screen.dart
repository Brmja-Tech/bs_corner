import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
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
    final mediaQuery = MediaQuery.of(context);
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
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: SizedBox(
                  height: mediaQuery.size.height * 0.6,
                  width: double.infinity,
                  child: TableWidget(
                    columns: [
                      DataColumn(
                        label: Label(
                          text: 'اسم الموظف',
                          overflow: TextOverflow.ellipsis,
                          style: context.appTextTheme.headlineSmall,
                        ),
                      ),
                      DataColumn(
                        label: Label(
                          text: 'مدة البداية',
                          style: context.appTextTheme.headlineSmall,
                        ),
                      ),
                      DataColumn(
                        label: Label(
                          text: 'مدة النهاية',
                          style: context.appTextTheme.headlineSmall,
                        ),
                      ),
                      DataColumn(
                        label: Label(
                          text: 'تفاصيل',
                          style: context.appTextTheme.headlineSmall,
                        ),
                      ),
                    ],
                    rows: state.shifts.map((item) {
                      return DataRow(cells: [

                        DataCell(Label(
                          text: item['shift_user_name'] ?? '',
                          // Access 'name' from the map
                          style: context.appTextTheme.headlineSmall,
                        )),
                        DataCell(Label(
                          text: formatDateTime(item['from_time']),
                          style: context.appTextTheme.headlineSmall,
                        )),
                        DataCell(Label(
                          text: formatDateTime(item['to_time']),
                          style: context.appTextTheme.headlineSmall,
                        )),
                        DataCell(CustomButton(text: 'عرض', onPressed: () {})),
                      ]);
                    }).toList(),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 0),
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

  String formatDateTime(String dateTime) {
    final date = DateTime.parse(dateTime);
    // Format the date
    String formattedDate = DateFormat('yyyy/MM/dd').format(date);

    // Format the time
    int hour =
        date.hour % 12 == 0 ? 12 : date.hour % 12; // Convert to 12-hour format
    String minute = date.minute.toString().padLeft(2, '0');
    String period = date.hour < 12 ? 'صباحا' : 'مساء';

    return 'الساعة $hour:$minute $period  $formattedDate';
  }
}
