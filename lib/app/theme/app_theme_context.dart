import 'package:flutter/material.dart';

import 'app_color_tokens.dart';

extension AppThemeContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;

  AppColorTokens get appColors => Theme.of(this).extension<AppColorTokens>()!;

  TextTheme get textTheme => Theme.of(this).textTheme;
}
