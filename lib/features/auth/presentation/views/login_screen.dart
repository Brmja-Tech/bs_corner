import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/custom_text_field.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/core/stateless/responsive_scaffold.dart';
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
  final ScrollController scrollController = ScrollController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    scrollController.dispose();
    formKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
        color: Colors.white,
        desktopBody: Center(
          child: SizedBox(
            height: context.height * 0.8,
            width: context.width * 0.8,
            child: Row(
              children: [
                Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                          // color: Colors.yellow,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              blurRadius: 0,
                              // spreadRadius: 5,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              AppGaps.gap28Vertical,
                              Image.asset(
                                'assets/images/logo.png',
                                height: 150,
                              ),
                              AppGaps.gap28Vertical,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: CustomTextFormField(
                                  controller: nameController,
                                  hintText: 'اسم المستخدم',
                                  prefixIcon: Icons.person,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'اسم المستخدم مطلوب';
                                    }
                                    return '';
                                  },
                                ),
                              ),
                              AppGaps.gap28Vertical,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: CustomTextFormField(
                                    controller: passwordController,
                                    hintText: 'كلمة المرور',
                                    prefixIcon: Icons.lock,
                                    isPassword: true,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'كلمه المرور مطلوب';
                                      }
                                      return '';
                                    }),
                              ),
                              AppGaps.gap48Vertical,
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 35.0),
                                child: BlocConsumer<AuthBloc, AuthState>(
                                  listener: (context, state) {
                                    if (state.isError) {
                                      context.showErrorMessage(
                                          state.errorMessage ?? '');
                                    }
                                    if (state.isSuccess) {
                                      context.showSuccessMessage(
                                          'تمت عمليه تسجيل الدخول بنجاح');
                                      context.goWithNoReturn(BlocProvider(
                                          create: (context) =>
                                              sl<ReportsBloc>(),
                                          child: const HomeScreen()));
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state.isLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return CustomButton(
                                        text: 'تسجيل',
                                        width: double.infinity - 20,
                                        height: 60,
                                        onPressed: () {
                                          if (nameController.text.isNotEmpty ||
                                              passwordController
                                                  .text.isNotEmpty) {
                                            context.read<AuthBloc>().login(
                                                nameController.text,
                                                passwordController.text);
                                            return;
                                          }
                                          context.showErrorMessage(
                                              'ادخل بيانات التسجيل');
                                        });
                                  },
                                ),
                              ),
                              TextButton(
                                  onPressed: () =>
                                      context.go(const RegisterScreen()),
                                  child: const Label(
                                    text: 'إنشاء حساب',
                                    selectable: false,
                                  ))
                            ],
                          ),
                        ))),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(25, 82, 205, 1),
                        Color.fromRGBO(12, 40, 98, 1),
                      ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                    ),
                    child: Center(
                      child: Image.asset('assets/images/login.png'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
