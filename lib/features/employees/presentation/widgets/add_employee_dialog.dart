import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/enums/user_role_enum.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/stateless/custom_text_field.dart';
import 'package:pscorner/features/employees/presentation/blocs/employees_cubit.dart';

class AddEmployeeDialog extends StatefulWidget {
  const AddEmployeeDialog({super.key});

  @override
  State<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends State<AddEmployeeDialog> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isAdmin = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة موظف'),
      content: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              hintText: 'اسم الموظف',
              prefixIcon: Icons.person,
              controller: _usernameController,
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              hintText: 'كلمه المرور',
              prefixIcon: Icons.lock,
              controller: _passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text('هل هو مشرف؟'),
                const Spacer(),
                Switch(
                  activeColor: context.theme.primaryColor,
                  value: isAdmin,
                  onChanged: (value) {
                    setState(() {
                      isAdmin = value;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            final username = _usernameController.text.trim();
            final password = _passwordController.text.trim();

            if (username.isEmpty || password.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('يرجى ملء جميع الحقول')),
              );
              return;
            }

            context.read<EmployeesBloc>().insertEmployee(
                  username: username,
                  password: password,
                  role: isAdmin? UserRole.supervisor : UserRole.employee,
                );

            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('تأكيد'),
        ),
      ],
    );
  }
}
