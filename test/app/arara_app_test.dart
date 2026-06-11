import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/arara_app.dart';
import 'package:gestor_de_estoque/app/localization/app_strings.dart';
import 'package:gestor_de_estoque/app/theme/app_color_tokens.dart';
import 'package:gestor_de_estoque/app/theme/app_sizes.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';

void main() {
  testWidgets('configura tema claro, escuro e modo do sistema', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AraraApp()));
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(app.theme?.colorScheme, AppTheme.light.colorScheme);
    expect(app.darkTheme?.colorScheme, AppTheme.dark.colorScheme);
    expect(app.themeMode, ThemeMode.system);
  });

  for (final brightness in [Brightness.light, Brightness.dark]) {
    testWidgets('inicia na tela transitoria em ${brightness.name}', (
      tester,
    ) async {
      tester.platformDispatcher.platformBrightnessTestValue = brightness;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await tester.pumpWidget(const ProviderScope(child: AraraApp()));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.appName), findsOneWidget);
      expect(find.text(AppStrings.startupTitle), findsOneWidget);
      expect(find.text(AppStrings.startupMessage), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);

      final context = tester.element(find.byType(Scaffold));
      final theme = Theme.of(context);
      final tokens = theme.extension<AppColorTokens>()!;

      expect(theme.useMaterial3, isTrue);
      expect(tokens.surfaceHero, isNotNull);
      expect(
        theme.scaffoldBackgroundColor,
        brightness == Brightness.light
            ? AppTheme.light.scaffoldBackgroundColor
            : AppTheme.dark.scaffoldBackgroundColor,
      );
    });
  }

  for (final size in [const Size(360, 800), const Size(390, 844)]) {
    testWidgets(
      'StartupPage permanece utilizavel em ${size.width.toInt()}x${size.height.toInt()}',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const ProviderScope(child: AraraApp()));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text(AppStrings.appName), findsOneWidget);
        expect(find.textContaining('Tema global pronto'), findsOneWidget);

        final constrainedBoxes = tester
            .widgetList<ConstrainedBox>(find.byType(ConstrainedBox))
            .toList();

        expect(
          constrainedBoxes.any(
            (box) =>
                box.constraints.maxWidth == AppSizes.compactContentMaxWidth,
          ),
          isTrue,
        );
      },
    );
  }
}
