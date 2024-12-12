import 'package:flutter/material.dart';
import 'package:pscorner/core/helper/functions.dart';
import 'package:pscorner/core/stateless/custom_button.dart';
import 'package:pscorner/core/stateless/gaps.dart';
import 'package:pscorner/core/stateless/label.dart';
import 'package:pscorner/core/theme/text_theme.dart';


extension ThemeExtensions on BuildContext {
  // Method to get the theme data
  ThemeData get theme => Theme.of(this);

  // Method to get the text theme data
  TextTheme get appTextTheme => Theme.of(this).textTheme;

  //width
  double get width => MediaQuery.of(this).size.width;

  //height
  double get height => MediaQuery.of(this).size.height;

  goWithNoReturn(Widget widget, {String? routeName}) =>
      navToAndRemoveUntil(this, widget,routeName:  routeName);

  go(Widget widget, {String? routeName}) => navTo(this, widget,routeName: routeName);

  pop([Object? object]) => Navigator.of(this).pop(object);

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Label(
                text: message,
                selectable: false,
                style: AppTextTheme.bodyLarge.copyWith(color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.error,
              color: Colors.red,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        margin: const EdgeInsets.only(bottom: 25, right: 20, left: 20),
      ),
    );
  }

  void showSuccessMessage(
      String message, {
        Color color = Colors.green,
        IconData icon = Icons.check_circle,
      }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(this).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Label(
                  text: message,
                  selectable: false,
                  style: AppTextTheme.bodyLarge.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, color: color),
            ],
          ),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          margin: const EdgeInsets.only(bottom: 25, right: 20, left: 20),
        ),
      );
    });
  }

  void showSuccessDialog(String text) {
    showDialog(
      context: this,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: Label(
          text:text,
          selectable: false,
          style: AppTextTheme.bodyLarge.copyWith(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.all(20).copyWith(bottom: 40),
      ),
    );
  }

  void showLoadingDialog({
    String? message,
    bool canPop = false,
    bool barrierDismissible = false,
  }) {
    showDialog(
      context: this,
      barrierDismissible: barrierDismissible,
      builder: (_) => PopScope(
        canPop: canPop,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator.adaptive(),
              AppGaps.gap28Vertical,
              Text(
                message ?? 'تحميل البيانات...',
                style: AppTextTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          contentPadding: const EdgeInsets.all(20).copyWith(bottom: 40),
        ),
      ),
    );
  }

  void showConfirmDialog(
      String text,
      VoidCallback onConfirm, {
        String? confirmText,
        String? cancelText,
        VoidCallback? onCancel,
        TextStyle? cancelTextStyle,
        TextStyle? confirmTextStyle,
      }) {
    showDialog(
      context: this,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: Text(
          text,
          style: AppTextTheme.bodyLarge.copyWith(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.all(20).copyWith(bottom: 40),
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  style: theme.elevatedButtonTheme.style?.copyWith(
                      backgroundColor: WidgetStateProperty.all(
                          theme.colorScheme.secondary),
                      padding: WidgetStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 5))),
                  text: confirmText ?? 'مسح',
                  onPressed: () {
                    Navigator.of(this, rootNavigator: true).pop();
                    onConfirm.call();
                  },
                ),
              ),
              AppGaps.gap28Horizontal,
              Expanded(
                child: CustomButton(
                  text: cancelText ?? 'تراجع',
                  style: theme.elevatedButtonTheme.style?.copyWith(
                      backgroundColor:
                      WidgetStateProperty.all(theme.colorScheme.error),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      )),
                  onPressed: () {
                    Navigator.of(this, rootNavigator: true).pop();

                    onCancel?.call();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}