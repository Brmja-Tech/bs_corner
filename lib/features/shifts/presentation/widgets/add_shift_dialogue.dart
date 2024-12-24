import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/features/employees/presentation/blocs/employees_cubit.dart';
import 'package:pscorner/features/employees/presentation/blocs/employees_state.dart';
import 'package:pscorner/features/shifts/presentation/blocs/shifts_cubit.dart';

class AddShiftDialog extends StatefulWidget {
  const AddShiftDialog({super.key});

  @override
  State<AddShiftDialog> createState() => _AddShiftDialogState();
}

class _AddShiftDialogState extends State<AddShiftDialog> {
  String? selectedEmployeeId;
  String? selectedEmployeeName;

  DateTime? fromTime;
  DateTime? toTime;

  final TextEditingController fromTimeController = TextEditingController();
  final TextEditingController toTimeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافه شيفت'),
      content: BlocBuilder<EmployeesBloc, EmployeesState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.isSuccess) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dropdown for selecting employee
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'اسم الموظف'),
                  items: state.employees
                      .map((employee) => DropdownMenuItem<String>(
                    value: employee['id'].toString(),
                    child: Text(employee['username']),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedEmployeeId = value;
                      selectedEmployeeName = state.employees
                          .firstWhere((employee) => employee['id'].toString() == value)['username'];
                    });
                  },
                ),
                const SizedBox(height: 10),

                // DateTime picker for "from time"
                TextFormField(
                  controller: fromTimeController,
                  decoration: const InputDecoration(
                    labelText: 'مدة البداية',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      textDirection: TextDirection.ltr,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          fromTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          fromTimeController.text =
                          '${fromTime!.year}-${fromTime!.month.toString().padLeft(2, '0')}-${fromTime!.day.toString().padLeft(2, '0')} ${pickedTime.format(context)}';
                        });
                      }
                    }
                  },
                ),
                const SizedBox(height: 10),

                // DateTime picker for "to time"
                TextFormField(
                  controller: toTimeController,
                  decoration: const InputDecoration(
                    labelText: 'مدة النهاية',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      textDirection: TextDirection.ltr,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          toTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          toTimeController.text =
                          '${toTime!.year}-${toTime!.month.toString().padLeft(2, '0')}-${toTime!.day.toString().padLeft(2, '0')} ${pickedTime.format(context)}';
                        });
                      }
                    }
                  },
                ),
              ],
            );
          } else {
            return const Center(child: Text('Failed to load employees.'));
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            if (selectedEmployeeId != null &&
                fromTime != null &&
                toTime != null &&selectedEmployeeName != null) {
              context.read<ShiftsBloc>().insertShift(
                userName: selectedEmployeeName!,
                userId: int.parse(selectedEmployeeId!),
                totalCollectedMoney: 0,
                fromTime: fromTime!.toString(),
                toTime: toTime!.toString(),
              );
              Navigator.pop(context); // Close the dialog
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('يرجى ملء جميع الحقول.'),
              ));
            }
          },
          child: const Text('تأكيد'),
        ),
      ],
    );
  }
}
