import 'package:flutter/material.dart';
import 'package:pscorner/core/extensions/context_extension.dart';
import 'package:pscorner/main.dart';

import 'colors.dart';

class AppTextTheme {
  AppTextTheme._(); // Private constructor to prevent instantiation

  static TextStyle get displayLarge => TextStyle(
        color: navigatorKey.currentContext!.theme.colorScheme.onSurface,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get titleLarge => TextStyle(
        color: navigatorKey.currentContext!.theme.colorScheme.onSurface,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodyLarge => const TextStyle(
        color: AppColors.slateGrey,
        fontSize: 16,
      );

  static TextStyle get bodyMedium => const TextStyle(
        color: AppColors.slateGrey,
        fontSize: 14,
      );

  static TextStyle get labelLarge => TextStyle(
        color: navigatorKey.currentContext!.theme.colorScheme.onSecondary,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get bodySmall => const TextStyle(
        color: AppColors.slateGrey,
        fontSize: 12,
      );
}
