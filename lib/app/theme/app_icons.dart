import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

abstract final class AppIcons {
  const AppIcons._();

  static const IconData dashboard = LucideIcons.layoutDashboard;
  static const IconData insights = LucideIcons.barChart3;
  static const IconData products = LucideIcons.package;
  static const IconData sales = LucideIcons.receipt;
  static const IconData inventory = LucideIcons.warehouse;
  static const IconData more = LucideIcons.grid2X2;
  static const IconData account = LucideIcons.userCircle;
  static const IconData tenant = LucideIcons.building2;
  static const IconData openInNew = LucideIcons.externalLink;
  static const IconData lock = LucideIcons.lock;
  static const IconData wifiOff = LucideIcons.wifiOff;
  static const IconData storefront = LucideIcons.store;
  static const IconData schedule = LucideIcons.clock;
  static const IconData refresh = LucideIcons.refreshCw;
  static const IconData bolt = LucideIcons.zap;
  static const IconData arrowForward = LucideIcons.arrowRight;
  static const IconData arrowBack = LucideIcons.arrowLeft;
  static const IconData menu = LucideIcons.menu;
  static const IconData tune = LucideIcons.slidersHorizontal;
  static const IconData shield = LucideIcons.shield;
  static const IconData search = LucideIcons.search;
  static const IconData filter = LucideIcons.listFilter;
  static const IconData settings = LucideIcons.settings;
  static const IconData themeLight = LucideIcons.sun;
  static const IconData themeDark = LucideIcons.moon;
  static const IconData success = LucideIcons.checkCircle;
  static const IconData warning = LucideIcons.alertTriangle;
  static const IconData error = LucideIcons.xCircle;

  // New aliases for product categories
  static const IconData productProtection = LucideIcons.shieldCheck;
  static const IconData productElectrical = LucideIcons.cable;
  static const IconData productAccessories = LucideIcons.tag;
  static const IconData productFallback = LucideIcons.package;
}
