import 'package:flutter/material.dart';

abstract final class AppColors {
  static final background = _fromHsl(210, 33, 98);
  static final textPrimary = _fromHsl(215, 34, 15);
  static final surface = _fromHsl(0, 0, 100);
  static final primary = _fromHsl(213, 77, 46);
  static final border = _fromHsl(214, 23, 88);
  static final success = _fromHsl(152, 60, 42);
  static final warning = _fromHsl(38, 92, 50);
  static final error = _fromHsl(348, 83, 55);

  static Color _fromHsl(double hue, double saturation, double lightness) {
    return HSLColor.fromAHSL(
      1,
      hue,
      saturation / 100,
      lightness / 100,
    ).toColor();
  }
}
