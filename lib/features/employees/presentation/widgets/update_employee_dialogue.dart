import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/stateful/custom_drop_down_form_field.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/theme/text_theme.dart';
import 'package:pscorner/features/employees/presentation/blocs/employees_cubit.dart';
import 'package:pscorner/features/employees/presentation/blocs/employees_state.dart';

class UpdateEmployeeDialogue extends StatefulWidget {
  final int id;
  final String role;

  const UpdateEmployeeDialogue(
      {super.key, required this.id, required this.role});

  @override
  State<UpdateEmployeeDialogue> createState() => _UpdateEmployeeDialogueState();
}

class _UpdateEmployeeDialogueState extends State<UpdateEmployeeDialogue> {
  List<String> items = [
    'مدير',
    'موظف',
  ];
  String value = '';
  bool isAdmin = false;

  @override
  initState() {
    value = widget.role;
    isAdmin = value == 'مدير';
    super.initState();
  }


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void onChanged(String? value) {
    if (value != null) {
      setState(() {
        this.value = value;
        isAdmin = value == 'مدير';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تعديل  موظف'),
      content: SizedBox(
        width: context.width * 0.8,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomDropdownField<String>(
                hintText: 'اختر الصلاحيه',
                items: items,
                // itemStyle: ,
                // hintStyle: ,
                onChanged: onChanged,
                validator: (String? value) =>
                    value!.isEmpty ? 'من فضلك اختر صلاحيه' : null,
                value: value.isEmpty ? null : value,
                hintStyle: AppTextTheme.bodyLarge,
                itemStyle: AppTextTheme.bodyLarge
                    .copyWith(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BlocConsumer<EmployeesBloc, EmployeesState>(
              listener: (context, state) {
                if (state.isSuccess) {
                  context.showSuccessMessage('تم التعديل بنجاح');
                  context.pop();
                }
                if (state.isError) {
                  context.showErrorMessage(state.errorMessage!);
                }
              },
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return CustomButton(
                    text: 'تأكيد',
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context
                            .read<EmployeesBloc>()
                            .updateEmployee(id: widget.id, isAdmin: isAdmin);
                      }
                    });
              },
            ),
            CustomButton(
                text: 'رجوع',
                style: context.theme.elevatedButtonTheme.style?.copyWith(
                    backgroundColor: WidgetStateProperty.all(
                        context.theme.colorScheme.error),
                    padding: WidgetStateProperty.all(const EdgeInsets.all(20))),
                onPressed: () => context.pop()),
          ],
        ),
      ],
    );
  }
}
