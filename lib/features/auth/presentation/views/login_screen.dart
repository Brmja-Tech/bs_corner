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
import 'package:pscorner/features/auth/presentation/views/register_screen.dart';
import 'package:pscorner/features/home/presentation/views/home_screen.dart';
import 'package:pscorner/features/reports/presentation/blocs/reports_cubit.dart';
import 'package:pscorner/service_locator/service_locator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      // color: const Color.fromRGBO(5, 13, 225, 0.5),
      desktopBody: Center(
        child: Container(
          width: context.screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
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
                    context.goWithNoReturn(BlocProvider(create: (context)=>sl<ReportsBloc>(), child: const HomeScreen()));
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
                    text: 'تسجيل الدخول',
                    onPressed: () {
                      loggerWarn('tapped');
                      context
                          .read<AuthBloc>()
                          .login(nameController.text, passwordController.text);
                    },
                  );
                },
              ),
              InkWell(
                onTap: () => context.go(const RegisterScreen()),
                child: Label(
                  text: 'ليس لديك حساب',
                  decoration: TextDecoration.underline,
                  style: AppTextTheme.bodyLarge.copyWith(color: Colors.blue),
                  selectable: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
