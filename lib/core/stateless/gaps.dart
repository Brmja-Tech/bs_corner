// lib/app_gaps.dart
import 'package:flutter/material.dart';

class AppGaps {
  AppGaps._(); // Private constructor to prevent instantiation

  /// Gap4: 4 pixels
  static Widget get gap4Vertical => const SizedBox(height: 4);
  static Widget get gap4Horizontal => const SizedBox(width: 4);

  /// Gap8: 8 pixels
  static Widget get gap8Vertical => const SizedBox(height: 8);
  static Widget get gap8Horizontal => const SizedBox(width: 8);

  /// Gap16: 16 pixels
  static Widget get gap16Vertical => const SizedBox(height: 16);
  static Widget get gap16Horizontal => const SizedBox(width: 16);

  /// Gap28: 28 pixels
  static Widget get gap28Vertical => const SizedBox(height: 28);
  static Widget get gap28Horizontal => const SizedBox(width: 28);

// Add more gap sizes as needed
  static Widget  gapCustomVertical(double height) =>  SizedBox(height: height);
  static Widget  gapCustomHorizontal(double width) =>  SizedBox(width: width);

}