import 'package:flutter/material.dart';

abstract final class AppColors {
  const AppColors._();

  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // Light theme primitives derived from the canonical HSL tokens.
  static const background = Color(0xFFF8FAFC);
  static const foreground = Color(0xFF192433);
  static const surface = Color(0xFFFFFFFF);
  static const primary = Color(0xFF1B6CD0);
  static const secondary = Color(0xFFECF0F3);
  static const secondaryForeground = Color(0xFF364459);
  static const muted = Color(0xFFE7EBEE);
  static const mutedForeground = Color(0xFF5D6979);
  static const accent = Color(0xFFEDF2F7);
  static const accentForeground = Color(0xFF1659AC);
  static const border = Color(0xFFD9DFE7);
  static const success = Color(0xFF2BAB6F);
  static const warning = Color(0xFFF59F0A);
  static const danger = Color(0xFFEB2D53);

  // Platform and operational palettes.
  static const sidebarOperational = Color(0xFF0B1A2B);
  static const sidebarOperationalForeground = Color(0xFFE7EEF8);
  static const sidebarAdmin = Color(0xFF0D1B2A);
  static const adminAccent = Color(0xFF6D4DFF);

  // Light tonal primitives.
  static const successContainerLight = Color(0xFFE6F6EE);
  static const successForegroundLight = Color(0xFF1D6B48);
  static const warningContainerLight = Color(0xFFFFF1D6);
  static const warningForegroundLight = Color(0xFF8A5B00);
  static const dangerContainerLight = Color(0xFFFDE8ED);
  static const dangerForegroundLight = Color(0xFFA41D3E);
  static const restrictedLight = Color(0xFFEEF2F7);
  static const restrictedForegroundLight = Color(0xFF4B5C73);
  static const focusLight = Color(0x801B6CD0);

  // Dark theme primitives.
  static const backgroundDark = Color(0xFF07111F);
  static const surfaceDark = Color(0xFF0B1728);
  static const surfaceMutedDark = Color(0xFF111E31);
  static const surfaceHeroDark = Color(0xFF06101D);
  static const borderDark = Color(0xFF223149);
  static const foregroundDark = Color(0xFFE6EDF7);
  static const mutedForegroundDark = Color(0xFF9BAAC0);
  static const primaryDark = Color(0xFF6EA8FF);
  static const successDark = Color(0xFF36D399);
  static const warningDark = Color(0xFFFBBF24);
  static const dangerDark = Color(0xFFFB7185);

  // Dark tonal primitives.
  static const successContainerDark = Color(0xFF123726);
  static const successForegroundDark = Color(0xFFA5F0CC);
  static const warningContainerDark = Color(0xFF49320A);
  static const warningForegroundDark = Color(0xFFFFE3A0);
  static const dangerContainerDark = Color(0xFF4B1826);
  static const dangerForegroundDark = Color(0xFFFFC0CB);
  static const restrictedDark = Color(0xFF172332);
  static const restrictedForegroundDark = Color(0xFFC9D4E2);
  static const focusDark = Color(0x996EA8FF);

  // Shared chart palette.
  static const chart1Light = primary;
  static const chart2Light = Color(0xFF2E8A78);
  static const chart3Light = Color(0xFF1E3A5F);
  static const chart4Light = Color(0xFFE0A100);
  static const chart5Light = Color(0xFFF08A4B);

  static const chart1Dark = primaryDark;
  static const chart2Dark = Color(0xFF43C1A6);
  static const chart3Dark = Color(0xFF4F7DB8);
  static const chart4Dark = Color(0xFFF1C44F);
  static const chart5Dark = Color(0xFFF5A46B);
}
