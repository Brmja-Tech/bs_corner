import 'package:flutter/material.dart';
import 'package:pscorner/core/extensions/context_extension.dart';

import '../theme/text_theme.dart';
import 'label.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final ButtonStyle? style;
  final VoidCallback onPressed;
  final AlignmentGeometry? alignment;

  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      this.style,
      this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: alignment ?? Alignment.center,
        child: Container(
          margin: const EdgeInsets.only(left: 20),
          child: ElevatedButton(
            style: style ??
                context.theme.elevatedButtonTheme.style!.copyWith(
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 80, vertical: 20)),
                ),
            onPressed: onPressed,
            child: Label(
              text: text,
              selectable: false,
              style: AppTextTheme.labelLarge.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ));
  }
}
