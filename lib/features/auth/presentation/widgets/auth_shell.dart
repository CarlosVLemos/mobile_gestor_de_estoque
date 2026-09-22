import 'package:flutter/material.dart';

import '../../../../app/theme/app_decorations.dart';
import '../../../../app/theme/app_icons.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_sizes.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_theme_context.dart';

/// Estrutura visual compartilhada pelas superfícies de autenticação.
///
/// Mantém a apresentação de Auth coesa sem assumir regras de sessão,
/// navegação ou credencial.
class AuthShell extends StatelessWidget {
  const AuthShell({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: AppDecorations.atmosphericBackground(context),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 360;
            final horizontalPadding = compact ? AppSpacing.lg : AppSpacing.xl;

            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                AppSpacing.xl,
                horizontalPadding,
                AppSpacing.xxxl + MediaQuery.viewInsetsOf(context).bottom,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: AppSizes.compactContentMaxWidth,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _AuthBrand(),
                      const SizedBox(height: AppSpacing.xxl),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: context.appColors.onSurfaceMuted,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      DecoratedBox(
                        decoration: AppDecorations.elevatedCard(context),
                        child: Padding(
                          padding: EdgeInsets.all(
                            compact ? AppSpacing.lg : AppSpacing.xl,
                          ),
                          child: child,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthBrand extends StatelessWidget {
  const _AuthBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.primaryContainer,
            borderRadius: AppRadius.xlBorder,
            border: Border.all(color: context.appColors.borderSubtle),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Icon(
              AppIcons.dashboard,
              size: AppSizes.emphasisIcon,
              color: context.colors.primary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'ARARA-GASTOS',
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.4,
          ),
        ),
      ],
    );
  }
}
