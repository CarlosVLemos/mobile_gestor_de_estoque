import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_color_tokens.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/app/theme/app_theme_context.dart';

void main() {
  testWidgets('BuildContext expõe os atalhos do tema ativo', (tester) async {
    late ColorScheme colors;
    late AppColorTokens tokens;
    late TextTheme textTheme;
    late TextTheme materialTextTheme;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: Builder(
          builder: (context) {
            colors = context.colors;
            tokens = context.appColors;
            textTheme = context.textTheme;
            materialTextTheme = Theme.of(context).textTheme;
            return const Scaffold();
          },
        ),
      ),
    );

    expect(colors.primary, AppTheme.light.colorScheme.primary);
    expect(colors.surface, AppTheme.light.colorScheme.surface);
    expect(tokens, AppTheme.light.extension<AppColorTokens>());
    expect(textTheme, materialTextTheme);
  });
}
