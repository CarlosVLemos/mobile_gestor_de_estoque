import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../theme/app_decorations.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import '../theme/app_theme_context.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: AppDecorations.atmosphericBackground(context),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    AppIcons.dashboard,
                    color: context.colors.primary,
                    size: 48,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AppStrings.appName.toUpperCase(),
                    style: context.textTheme.labelLarge?.copyWith(
                      color: context.colors.primary,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Validando sua sessão',
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Aguarde enquanto preparamos o acesso seguro.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.appColors.onSurfaceMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const SizedBox(width: 140, child: LinearProgressIndicator()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
