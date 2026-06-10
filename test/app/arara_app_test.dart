import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/arara_app.dart';
import 'package:gestor_de_estoque/app/localization/app_strings.dart';
import 'package:gestor_de_estoque/app/theme/app_colors.dart';

void main() {
  testWidgets('inicia na tela transitória com o tema central', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AraraApp()));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.startupTitle), findsOneWidget);
    expect(find.text(AppStrings.startupMessage), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);

    final context = tester.element(find.byType(Scaffold));
    final theme = Theme.of(context);

    expect(theme.useMaterial3, isTrue);
    expect(theme.colorScheme.primary, AppColors.primary);
    expect(theme.colorScheme.surface, AppColors.surface);
    expect(theme.colorScheme.onSurface, AppColors.textPrimary);
    expect(theme.colorScheme.outline, AppColors.border);
    expect(theme.colorScheme.error, AppColors.error);
    expect(theme.scaffoldBackgroundColor, AppColors.background);
    expect(theme.textTheme.bodyLarge?.fontFamily, isNot('Instrument Sans'));
  });

  for (final size in [const Size(360, 800), const Size(390, 844)]) {
    testWidgets(
      'permanece utilizável em ${size.width.toInt()}x${size.height.toInt()}',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(const ProviderScope(child: AraraApp()));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
        expect(find.text(AppStrings.appName), findsOneWidget);
        expect(find.text(AppStrings.startupMessage), findsOneWidget);
      },
    );
  }
}
