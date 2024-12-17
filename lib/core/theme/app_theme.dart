import 'package:flutter/material.dart';
import 'package:pscorner/core/theme/colors.dart';

class AppThemes {
  static ThemeData lightTheme() {
    // Define the ColorScheme
    final ColorScheme colorScheme = ColorScheme(
      primary: AppColors.deepNavyBlue,
      primaryContainer: AppColors.deepNavyBlue.withOpacity(0.7),
      secondary: AppColors.gold,
      secondaryContainer: AppColors.gold.withOpacity(0.7),
      surface: AppColors.elegantWhite,
      error: AppColors.crimsonRed,
      onPrimary: AppColors.elegantWhite,
      onSecondary: AppColors.elegantWhite,
      onSurface: AppColors.richBlack,
      onError: AppColors.elegantWhite,
      brightness: Brightness.light,
      onInverseSurface: AppColors.softBlue,
    );

    return ThemeData(
      // **Color Scheme**
      colorScheme: colorScheme,
      useMaterial3: true,
      // Opt-in to Material 3 for the latest components and theming

      // **Primary Color**
      primaryColor: colorScheme.primary,
      scaffoldBackgroundColor: Colors.white,
      // **App Bar Theme**
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,

        // Text and icon colors
        elevation: 4,
        titleTextStyle: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onPrimary,
        ),
      ),

      // **Text Theme**
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: const TextStyle(
          color: AppColors.slateGrey,
          fontSize: 16,
        ),
        bodyMedium: const TextStyle(
          color: AppColors.slateGrey,
          fontSize: 14,
        ),
        labelLarge: TextStyle(
          color: colorScheme.onSecondary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        bodySmall: const TextStyle(
          color: AppColors.slateGrey,
          fontSize: 12,
        ),
      ),

      // **Elevated Button Theme**
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.disabled)) {
                return colorScheme.primary.withOpacity(0.5);
              }
              return const Color.fromRGBO(44, 102, 153, 1); // Gold
            },
          ),
          foregroundColor: WidgetStateProperty.all<Color>(
            colorScheme.onSecondary, // Elegant White
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.hovered)) {
                return colorScheme.secondary.withOpacity(0.1);
              }
              if (states.contains(WidgetState.pressed)) {
                return colorScheme.secondary.withOpacity(0.2);
              }
              return null;
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(
            const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          elevation: WidgetStateProperty.all<double>(5),
        ),
      ),
      hoverColor: Colors.transparent,

      // **Text Button Theme**
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.hovered)) {
                return colorScheme.primary.withOpacity(0.7);
              }
              return colorScheme.primary; // Deep Navy Blue
            },
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.hovered)) {
                return colorScheme.primary.withOpacity(0.1);
              }
              if (states.contains(WidgetState.pressed)) {
                return colorScheme.primary.withOpacity(0.2);
              }
              return null;
            },
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(
            const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),

      // **Outlined Button Theme**
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.hovered)) {
                return colorScheme.primary.withOpacity(0.7);
              }
              return colorScheme.primary; // Deep Navy Blue
            },
          ),
          side: WidgetStateProperty.resolveWith<BorderSide>(
            (states) {
              if (states.contains(WidgetState.hovered)) {
                return BorderSide(
                  color: colorScheme.primary.withOpacity(0.7),
                  width: 2.0,
                );
              }
              return BorderSide(
                color: colorScheme.primary,
                width: 2.0,
              );
            },
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
              if (states.contains(WidgetState.hovered)) {
                return colorScheme.primary.withOpacity(0.1);
              }
              if (states.contains(WidgetState.pressed)) {
                return colorScheme.primary.withOpacity(0.2);
              }
              return null;
            },
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(
            const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),

      // **Input Decoration Theme**
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightGrey,
        focusColor: colorScheme.secondary,
        // Gold
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.slateGrey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: AppColors.slateGrey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: colorScheme.secondary),
        ),
        labelStyle: const TextStyle(color: AppColors.slateGrey),
        hintStyle: const TextStyle(color: AppColors.slateGrey),
        prefixIconColor: colorScheme.primary,
        suffixIconColor: colorScheme.primary,
      ),

      // **Text Selection Theme**
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colorScheme.primary,
        // Deep Navy Blue
        selectionColor: colorScheme.secondary.withOpacity(0.5),
        // Gold with opacity
        selectionHandleColor: colorScheme.secondary, // Gold
      ),

      // **Icon Theme**
      iconTheme: IconThemeData(
        color: colorScheme.primary,
      ),

      // **Floating Action Button Theme**
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.secondary, // Gold
        foregroundColor: colorScheme.onSecondary, // Elegant White
      ),

      // **Tooltip Theme**
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.9),
          // Deep Navy Blue with opacity
          borderRadius: BorderRadius.circular(4.0),
        ),
        textStyle: TextStyle(
          color: colorScheme.onPrimary,
        ),
      ),

      // **Divider Color**
      dividerColor: AppColors.slateGrey,

      // **Card Theme**
      cardTheme: CardTheme(
        color: colorScheme.surface, // Elegant White
        shadowColor: AppColors.slateGrey.withOpacity(0.2),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),

      // **SnackBar Theme**
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.primary, // Deep Navy Blue
        contentTextStyle: TextStyle(color: colorScheme.onPrimary),
      ),

      // **Dialog Theme**
      dialogTheme: DialogTheme(
        backgroundColor: colorScheme.surface, // Elegant White
        titleTextStyle: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
          color: AppColors.slateGrey,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),

      // **TabBar Theme**
      tabBarTheme: TabBarTheme(
        labelColor: colorScheme.secondary, // Gold
        unselectedLabelColor: AppColors.slateGrey,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colorScheme.secondary, width: 2.0),
        ),
      ),

      // **Checkbox Theme**
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(colorScheme.secondary), // Gold
        checkColor:
            WidgetStateProperty.all(colorScheme.onSecondary), // Elegant White
      ),

      // **Radio Theme**
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.all(colorScheme.secondary), // Gold
      ),

      // **Switch Theme**
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(colorScheme.secondary), // Gold
        trackColor: WidgetStateProperty.all(AppColors.slateGrey),
      ),
    );
  }
}
