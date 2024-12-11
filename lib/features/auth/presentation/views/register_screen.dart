import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/core/stateless/responsive_scaffold.dart';
import 'package:pscorner/core/theme/text_theme.dart';
import 'package:pscorner/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:pscorner/features/auth/presentation/blocs/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(title: const Text('تسجيل حساب جديد')),
      desktopBody: Form(
        key : formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Label(
              text: 'تسجيل الدخول',
            ),
            const SizedBox(height: 32),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ' الرجاء ادخال اسم المستخدم';
                }
                return null;
              },
              controller: nameController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'اسم المستخدم',
                hintStyle: AppTextTheme.bodyMedium
                    .copyWith(color: context.theme.primaryColor),
                labelStyle: AppTextTheme.bodyMedium
                    .copyWith(color: context.theme.primaryColor),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: context.theme.primaryColor),
                ),
                border: const OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return ' الرجاء ادخال كلمة المرور';
                }
                return null;
              },
              textAlign: TextAlign.center,
              controller: passwordController,
              decoration: InputDecoration(
                hintText: 'كلمة المرور',
                hintStyle: AppTextTheme.bodyMedium
                    .copyWith(color: context.theme.primaryColor),
                labelStyle: AppTextTheme.bodyMedium
                    .copyWith(color: context.theme.primaryColor),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.orange),
                ),
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 24),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (listener, state) {
                if (state.isSuccess) {
                  context.showSuccessMessage('تم تسجيل الدخول بنجاح');
                }
                if (state.isError) {
                  context.showErrorMessage(state.errorMessage!);
                }
              },
              builder: (builder, state) {
                if (state.status == AuthStateStatus.loading) {
                  return const CircularProgressIndicator();
                }

                return CustomButton(
                  text: 'تسجيل حساب جديد',
                  onPressed: () {
                    if(formKey.currentState!.validate()) {
                      context
                        .read<AuthBloc>()
                        .register(nameController.text, passwordController.text);
                    }
                    logger('${nameController.text} ${passwordController.text}');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
