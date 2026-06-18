import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/arara_app.dart';
import 'package:gestor_de_estoque/app/localization/app_strings.dart';
import 'package:gestor_de_estoque/app/theme/app_color_tokens.dart';
import 'package:gestor_de_estoque/app/theme/app_icons.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/shared/widgets/app_bottom_navigation.dart';

void main() {
  testWidgets('configura tema claro, escuro e modo inicial do sistema', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: AraraApp()));
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(app.theme?.colorScheme, AppTheme.light.colorScheme);
    expect(app.darkTheme?.colorScheme, AppTheme.dark.colorScheme);
    expect(app.themeMode, ThemeMode.system);
  });

  for (final brightness in [Brightness.light, Brightness.dark]) {
    testWidgets('parte de startup e entra na shell em ${brightness.name}', (
      tester,
    ) async {
      tester.platformDispatcher.platformBrightnessTestValue = brightness;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

      await tester.pumpWidget(const ProviderScope(child: AraraApp()));
      await tester.pump();
      await tester.pump();

      expect(find.text(AppStrings.startupTitle), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byType(AppBottomNavigation),
          matching: find.text(AppStrings.shellDashboard),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AppBottomNavigation),
          matching: find.text(AppStrings.shellProducts),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AppBottomNavigation),
          matching: find.text(AppStrings.shellSales),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(AppBottomNavigation),
          matching: find.text(AppStrings.shellMore),
        ),
        findsOneWidget,
      );
      expect(find.text('ATUALIZAÇÃO'), findsOneWidget);
      expect(find.byType(Scaffold), findsWidgets);

      final context = tester.element(find.byType(Scaffold).first);
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
      'shell operacional permanece utilizavel em ${size.width.toInt()}x${size.height.toInt()}',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const ProviderScope(child: AraraApp()));
        await tester.pump(const Duration(milliseconds: 350));
        await tester.pumpAndSettle();

        expect(
          find.descendant(
            of: find.byType(AppBottomNavigation),
            matching: find.text(AppStrings.shellDashboard),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(AppBottomNavigation),
            matching: find.text(AppStrings.shellProducts),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(AppBottomNavigation),
            matching: find.text(AppStrings.shellSales),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byType(AppBottomNavigation),
            matching: find.text(AppStrings.shellMore),
          ),
          findsOneWidget,
        );
      },
    );
  }

  testWidgets('toggle de tema sai do modo sistema durante a sessão', (
    tester,
  ) async {
    tester.platformDispatcher.platformBrightnessTestValue = Brightness.light;
    addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

    await tester.pumpWidget(const ProviderScope(child: AraraApp()));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(AppIcons.themeDark));
    await tester.pumpAndSettle();

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
    expect(find.byIcon(AppIcons.themeLight), findsOneWidget);
  });

  testWidgets('menu lateral abre a partir do painel', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AraraApp()));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(AppIcons.menu).first);
    await tester.pumpAndSettle();

    expect(find.text('Ver conta'), findsOneWidget);
    expect(find.text('Alterar nome'), findsOneWidget);
  });

  testWidgets('drawer abre conta e retorna ao painel', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AraraApp()));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(AppIcons.menu).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ver conta'));
    await tester.pumpAndSettle();

    expect(find.text('Conta'), findsWidgets);
    expect(find.text('Vínculo da conta'), findsOneWidget);

    await tester.tap(find.byIcon(AppIcons.arrowBack));
    await tester.pumpAndSettle();

    expect(find.text('Painel'), findsWidgets);
  });

  testWidgets('todas as rotas da shell suportam 320px com textScaler 2.0', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const ProviderScope(child: AraraApp()));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();
    _expectNoFlutterException(tester, 'Painel');

    for (final label in [
      AppStrings.shellProducts,
      AppStrings.shellSales,
      AppStrings.shellMore,
      AppStrings.shellDashboard,
    ]) {
      await tester.tap(
        find.descendant(
          of: find.byType(AppBottomNavigation),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
      _expectNoFlutterException(tester, label);
    }
  });

  testWidgets('drawer e edição de nome suportam layout compacto ampliado', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const ProviderScope(child: AraraApp()));
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(AppIcons.menu).first);
    await tester.pumpAndSettle();
    _expectNoFlutterException(tester, 'Drawer');

    final actionFinder = find.text('Alterar nome');
    await tester.drag(
      find.descendant(
        of: find.byType(Drawer),
        matching: find.byType(ListView),
      ),
      const Offset(0, -300),
    );
    await tester.pumpAndSettle();

    await tester.tap(actionFinder);
    await tester.pumpAndSettle();
    _expectNoFlutterException(tester, 'Edição de nome');
    expect(find.text('Cancelar'), findsOneWidget);
    expect(find.text('Salvar'), findsOneWidget);
  });
}

void _expectNoFlutterException(WidgetTester tester, String context) {
  final error = tester.takeException();
  if (error is FlutterError) {
    fail('$context apresentou erro:\n${error.toStringDeep()}');
  }
  expect(
    error,
    isNull,
    reason: 'A rota $context apresentou erro em layout compacto.',
  );
}
