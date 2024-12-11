import 'package:flutter/material.dart';
import 'package:pscorner/core/theme/text_theme.dart';


class Label extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final TextDecoration? decoration;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool selectable;
  const Label({
    super.key,
    required this.text,
    this.style,
    this.textAlign = TextAlign.start,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.decoration,
    this.color,
    this.fontSize,
    this.fontWeight,  this.selectable = true,
  });

  @override
  Widget build(BuildContext context) {

    if (!selectable) {
      return Text(
        text,
        style: (style ?? AppTextTheme.bodyLarge).copyWith(
          decoration: decoration,
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      );
    }
    return SelectableText(
      text,
      style: (style ?? AppTextTheme.bodyLarge).copyWith(
        decoration: decoration,
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,

      ),

      textAlign: textAlign,
      maxLines: maxLines,

    );
  }
}