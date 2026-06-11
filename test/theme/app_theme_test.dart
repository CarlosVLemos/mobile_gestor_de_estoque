import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gestor_de_estoque/app/theme/app_color_tokens.dart';
import 'package:gestor_de_estoque/app/theme/app_colors.dart';
import 'package:gestor_de_estoque/app/theme/app_radius.dart';
import 'package:gestor_de_estoque/app/theme/app_sizes.dart';
import 'package:gestor_de_estoque/app/theme/app_spacing.dart';
import 'package:gestor_de_estoque/app/theme/app_theme.dart';
import 'package:gestor_de_estoque/app/theme/app_typography.dart';

void main() {
  group('estrutura do tema', () {
    test('os onze arquivos exigidos existem em lib/app/theme', () {
      const requiredFiles = [
        'lib/app/theme/app_theme.dart',
        'lib/app/theme/app_colors.dart',
        'lib/app/theme/app_color_tokens.dart',
        'lib/app/theme/app_theme_context.dart',
        'lib/app/theme/app_typography.dart',
        'lib/app/theme/app_spacing.dart',
        'lib/app/theme/app_radius.dart',
        'lib/app/theme/app_shadows.dart',
        'lib/app/theme/app_sizes.dart',
        'lib/app/theme/app_decorations.dart',
        'lib/app/theme/app_icons.dart',
      ];

      for (final path in requiredFiles) {
        expect(
          File(path).existsSync(),
          isTrue,
          reason: 'Arquivo ausente: $path',
        );
      }
    });
  });

  group('tokens canonicos claros', () {
    test('conversoes HSL viraram constantes hex equivalentes', () {
      expect(AppColors.background, _fromHsl(210, 33, 98));
      expect(AppColors.foreground, _fromHsl(215, 34, 15));
      expect(AppColors.surface, _fromHsl(0, 0, 100));
      expect(AppColors.primary, _fromHsl(213, 77, 46));
      expect(AppColors.secondary, _fromHsl(210, 21, 94));
      expect(AppColors.secondaryForeground, _fromHsl(215, 25, 28));
      expect(AppColors.muted, _fromHsl(210, 18, 92));
      expect(AppColors.mutedForeground, _fromHsl(215, 13, 42));
      expect(AppColors.accent, _fromHsl(212, 41, 95));
      expect(AppColors.accentForeground, _fromHsl(213, 77, 38));
      expect(AppColors.border, _fromHsl(214, 23, 88));
      expect(AppColors.success, _fromHsl(152, 60, 42));
      expect(AppColors.warning, _fromHsl(38, 92, 50));
      expect(AppColors.danger, _fromHsl(348, 83, 55));
    });

    test('paletas operacionais e admin permanecem documentadas', () {
      expect(AppColors.sidebarOperational, const Color(0xFF0B1A2B));
      expect(AppColors.sidebarAdmin, const Color(0xFF0D1B2A));
      expect(AppColors.adminAccent, const Color(0xFF6D4DFF));
    });
  });

  group('extensao semantica', () {
    test('os dois temas registram AppColorTokens', () {
      expect(AppTheme.light.extension<AppColorTokens>(), isNotNull);
      expect(AppTheme.dark.extension<AppColorTokens>(), isNotNull);
    });

    test('copyWith preserva campos nao alterados e lerp interpola', () {
      const light = AppColorTokens(
        surfaceMuted: Color(0xFF000001),
        surfaceHero: Color(0xFF000002),
        onSurfaceHero: Color(0xFF000003),
        onSurfaceMuted: Color(0xFF000004),
        success: Color(0xFF000005),
        onSuccess: Color(0xFF000006),
        successContainer: Color(0xFF000007),
        onSuccessContainer: Color(0xFF000008),
        warning: Color(0xFF000009),
        onWarning: Color(0xFF00000A),
        warningContainer: Color(0xFF00000B),
        onWarningContainer: Color(0xFF00000C),
        restricted: Color(0xFF00000D),
        onRestricted: Color(0xFF00000E),
        borderSubtle: Color(0xFF00000F),
        focusRing: Color(0xFF000010),
        sidebarOperational: Color(0xFF000011),
        sidebarOperationalForeground: Color(0xFF000012),
        sidebarAdmin: Color(0xFF000013),
        sidebarAdminAccent: Color(0xFF000014),
        chart1: Color(0xFF000015),
        chart2: Color(0xFF000016),
        chart3: Color(0xFF000017),
        chart4: Color(0xFF000018),
        chart5: Color(0xFF000019),
        atmosphericGradient: LinearGradient(
          colors: [Color(0xFF111111), Color(0xFF222222)],
        ),
        heroGradient: LinearGradient(
          colors: [Color(0xFF333333), Color(0xFF444444)],
        ),
        authGradient: LinearGradient(
          colors: [Color(0xFF555555), Color(0xFF666666)],
        ),
      );
      const dark = AppColorTokens(
        surfaceMuted: Color(0xFF100001),
        surfaceHero: Color(0xFF100002),
        onSurfaceHero: Color(0xFF100003),
        onSurfaceMuted: Color(0xFF100004),
        success: Color(0xFF100005),
        onSuccess: Color(0xFF100006),
        successContainer: Color(0xFF100007),
        onSuccessContainer: Color(0xFF100008),
        warning: Color(0xFF100009),
        onWarning: Color(0xFF10000A),
        warningContainer: Color(0xFF10000B),
        onWarningContainer: Color(0xFF10000C),
        restricted: Color(0xFF10000D),
        onRestricted: Color(0xFF10000E),
        borderSubtle: Color(0xFF10000F),
        focusRing: Color(0xFF100010),
        sidebarOperational: Color(0xFF100011),
        sidebarOperationalForeground: Color(0xFF100012),
        sidebarAdmin: Color(0xFF100013),
        sidebarAdminAccent: Color(0xFF100014),
        chart1: Color(0xFF100015),
        chart2: Color(0xFF100016),
        chart3: Color(0xFF100017),
        chart4: Color(0xFF100018),
        chart5: Color(0xFF100019),
        atmosphericGradient: LinearGradient(
          colors: [Color(0xFFAAAAAA), Color(0xFFBBBBBB)],
        ),
        heroGradient: LinearGradient(
          colors: [Color(0xFFCCCCCC), Color(0xFFDDDDDD)],
        ),
        authGradient: LinearGradient(
          colors: [Color(0xFFEEEEEE), Color(0xFFFFFFFF)],
        ),
      );

      final copied = light.copyWith(chart3: const Color(0xFFABCDEF));
      final lerped = light.lerp(dark, 0.5);

      expect(copied.chart3, const Color(0xFFABCDEF));
      expect(copied.chart4, light.chart4);
      expect(lerped.chart1, isNot(light.chart1));
      expect(lerped.atmosphericGradient, isA<Gradient>());
    });
  });

  group('temas claro e escuro', () {
    test('o tema escuro possui paleta dedicada', () {
      final light = AppTheme.light.colorScheme;
      final dark = AppTheme.dark.colorScheme;
      final darkTokens = AppTheme.dark.extension<AppColorTokens>()!;

      expect(dark.brightness, Brightness.dark);
      expect(dark.surface, const Color(0xFF0B1728));
      expect(dark.onSurface, const Color(0xFFE6EDF7));
      expect(dark.primary, const Color(0xFF6EA8FF));
      expect(dark.surface, isNot(light.surface));
      expect(
        dark.surfaceContainerHighest,
        isNot(light.surfaceContainerHighest),
      );
      expect(darkTokens.surfaceHero, const Color(0xFF06101D));
    });

    test('ThemeData dos controles principais fica configurado', () {
      final light = AppTheme.light;
      final dark = AppTheme.dark;

      expect(light.useMaterial3, isTrue);
      expect(dark.useMaterial3, isTrue);
      expect(
        light.filledButtonTheme.style?.minimumSize?.resolve(<WidgetState>{}),
        const Size.fromHeight(AppSizes.buttonHeight),
      );
      expect(
        dark.outlinedButtonTheme.style?.side?.resolve(<WidgetState>{}),
        isA<BorderSide>(),
      );
      expect(light.navigationBarTheme.height, 76);
      expect(dark.progressIndicatorTheme.color, dark.colorScheme.primary);
    });
  });

  group('escalas globais', () {
    test('espacamento segue a ordem documentada', () {
      expect(
        [
          AppSpacing.xxs,
          AppSpacing.xs,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.lg,
          AppSpacing.xl,
          AppSpacing.xxl,
          AppSpacing.xxxl,
        ],
        [2, 4, 8, 12, 16, 24, 32, 40],
      );
      expect(AppSpacing.screenPadding.horizontal, AppSpacing.lg * 2);
      expect(AppSpacing.cardPadding.top, AppSpacing.lg);
    });

    test('raios e tamanhos respeitam a spec', () {
      expect(AppRadius.sm, 8);
      expect(AppRadius.md, 10);
      expect(AppRadius.lg, 12);
      expect(AppRadius.xl, 16);
      expect(AppRadius.hero, 28);
      expect(AppSizes.minTouchTarget, greaterThanOrEqualTo(48));
      expect(AppSizes.compactContentMaxWidth, 440);
    });
  });

  group('tipografia', () {
    test('usa fallback do sistema quando Instrument Sans nao existe', () {
      final textTheme = AppTheme.light.textTheme;

      expect(AppTypography.hasInstrumentSansAssets, isFalse);
      expect(
        textTheme.bodyLarge?.fontFamily,
        isNot(AppTypography.instrumentSansFamily),
      );
      expect(textTheme.bodyLarge?.fontSize, inInclusiveRange(14, 16));
      expect(textTheme.bodySmall?.fontSize, inInclusiveRange(12, 13));
      expect(textTheme.labelMedium?.letterSpacing, greaterThan(1));
      expect(
        textTheme.headlineMedium?.fontWeight?.value,
        greaterThanOrEqualTo(FontWeight.w600.value),
      );
    });
  });

  group('guardrails estaticos', () {
    test('nao usa AppColors fora da montagem do tema', () {
      final dartFiles = Directory('lib')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'));

      for (final file in dartFiles) {
        final normalized = file.path.replaceAll('\\', '/');
        final contents = file.readAsStringSync();

        if (normalized.startsWith('lib/app/theme/')) {
          continue;
        }

        expect(
          contents.contains('AppColors.'),
          isFalse,
          reason: 'Uso direto de AppColors fora do tema em $normalized',
        );
      }
    });

    test(
      'nao usa cores fixas ou papeis depreciados nas superficies migradas',
      () {
        final dartFiles = Directory('lib')
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'));

        for (final file in dartFiles) {
          final normalized = file.path.replaceAll('\\', '/');
          final contents = file.readAsStringSync();

          expect(
            RegExp(r'\bColors\.white\b').hasMatch(contents),
            isFalse,
            reason: 'Colors.white encontrado em $normalized',
          );
          expect(
            RegExp(r'\bColors\.black\b').hasMatch(contents),
            isFalse,
            reason: 'Colors.black encontrado em $normalized',
          );
          expect(
            contents.contains('colorScheme.background'),
            isFalse,
            reason: 'colorScheme.background encontrado em $normalized',
          );
          expect(
            contents.contains('colorScheme.onBackground'),
            isFalse,
            reason: 'colorScheme.onBackground encontrado em $normalized',
          );
          expect(
            contents.contains('surfaceVariant'),
            isFalse,
            reason: 'surfaceVariant encontrado em $normalized',
          );
        }
      },
    );
  });
}

Color _fromHsl(double hue, double saturation, double lightness) {
  return HSLColor.fromAHSL(1, hue, saturation / 100, lightness / 100).toColor();
}
