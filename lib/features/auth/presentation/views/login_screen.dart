import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/custom_text_field.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/responsive_scaffold.dart';
import 'package:pscorner/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:pscorner/features/auth/presentation/blocs/auth_state.dart';
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
                        child: Column(
                          children: [
                            AppGaps.gap28Vertical,
                            Image.asset('assets/images/logo.png'),
                            AppGaps.gap28Vertical,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: CustomTextFormField(
                                  controller: nameController,
                                  hintText: 'اسم المستخدم',
                                  prefixIcon: Icons.email),
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
                              ),
                            ),
                            AppGaps.gap48Vertical,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35.0),
                              child: BlocConsumer<AuthBloc, AuthState>(
                                listener: (context, state) {
                                  if (state.isError) {
                                    context.showErrorMessage(
                                        state.errorMessage ?? '');
                                    context.goWithNoReturn(BlocProvider(
                                        create: (context) => sl<ReportsBloc>(),
                                        child: const HomeScreen()));
                                  }
                                  if (state.isSuccess) {
                                    context.showSuccessMessage(
                                        'تمت عمليه تسجيل الدخول بنجاح');
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
                                      onPressed: () => context
                                          .read<AuthBloc>()
                                          .login(nameController.text.trim(),
                                              passwordController.text.trim()));
                                },
                              ),
                            )
                          ],
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
        )

        // Center(
        //   child: Container(
        //     width: context.screenWidth,
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         const Label(
        //           text: 'تسجيل الدخول',
        //         ),
        //         const SizedBox(height: 32),
        //         TextFormField(
        //           validator: (value) {
        //             if (value == null || value.isEmpty) {
        //               return ' الرجاء ادخال اسم المستخدم';
        //             }
        //             return null;
        //           },
        //           controller: nameController,
        //           textAlign: TextAlign.center,
        //           decoration: InputDecoration(
        //             hintText: 'اسم المستخدم',
        //             hintStyle: AppTextTheme.bodyMedium
        //                 .copyWith(color: context.theme.primaryColor),
        //             labelStyle: AppTextTheme.bodyMedium
        //                 .copyWith(color: context.theme.primaryColor),
        //             focusedBorder: OutlineInputBorder(
        //               borderSide: BorderSide(color: context.theme.primaryColor),
        //             ),
        //             border: const OutlineInputBorder(),
        //           ),
        //           style: const TextStyle(color: Colors.black),
        //         ),
        //         const SizedBox(height: 16),
        //         TextFormField(
        //           validator: (value) {
        //             if (value == null || value.isEmpty) {
        //               return ' الرجاء ادخال كلمة المرور';
        //             }
        //             return null;
        //           },
        //           textAlign: TextAlign.center,
        //           controller: passwordController,
        //           decoration: InputDecoration(
        //             hintText: 'كلمة المرور',
        //             hintStyle: AppTextTheme.bodyMedium
        //                 .copyWith(color: context.theme.primaryColor),
        //             labelStyle: AppTextTheme.bodyMedium
        //                 .copyWith(color: context.theme.primaryColor),
        //             focusedBorder: const OutlineInputBorder(
        //               borderSide: BorderSide(color: Colors.orange),
        //             ),
        //             border: const OutlineInputBorder(),
        //           ),
        //           obscureText: true,
        //           style: const TextStyle(color: Colors.black),
        //         ),
        //         const SizedBox(height: 24),
        //         BlocConsumer<AuthBloc, AuthState>(
        //           listener: (listener, state) {
        //             if (state.isSuccess) {
        //               context.showSuccessMessage('تم تسجيل الدخول بنجاح');
        //
        //             }
        //             if (state.isError) {
        //               context.showErrorMessage(state.errorMessage!);
        //             }
        //           },
        //           builder: (builder, state) {
        //             if (state.status == AuthStateStatus.loading) {
        //               return const CircularProgressIndicator();
        //             }
        //             return CustomButton(
        //               text: 'تسجيل الدخول',
        //               onPressed: () {
        //                 loggerWarn('tapped');
        //                 context
        //                     .read<AuthBloc>()
        //                     .login(nameController.text, passwordController.text);
        //               },
        //             );
        //           },
        //         ),
        //         InkWell(
        //           onTap: () => context.go(const RegisterScreen()),
        //           child: Label(
        //             text: 'ليس لديك حساب',
        //             decoration: TextDecoration.underline,
        //             style: AppTextTheme.bodyLarge.copyWith(color: Colors.blue),
        //             selectable: false,
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
