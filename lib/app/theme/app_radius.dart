import 'package:flutter/widgets.dart';

abstract final class AppRadius {
  const AppRadius._();

  static const double sm = 8;
  static const double md = 10;
  static const double lg = 12;
  static const double xl = 16;
  static const double hero = 28;

  static const Radius radiusSm = Radius.circular(sm);
  static const Radius radiusMd = Radius.circular(md);
  static const Radius radiusLg = Radius.circular(lg);
  static const Radius radiusXl = Radius.circular(xl);
  static const Radius radiusHero = Radius.circular(hero);

  static const BorderRadius smBorder = BorderRadius.all(radiusSm);
  static const BorderRadius mdBorder = BorderRadius.all(radiusMd);
  static const BorderRadius lgBorder = BorderRadius.all(radiusLg);
  static const BorderRadius xlBorder = BorderRadius.all(radiusXl);
  static const BorderRadius heroBorder = BorderRadius.all(radiusHero);
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
}
