import 'package:flutter/material.dart';

import '../../app/theme/app_icons.dart';

/// Campo de busca visual compartilhado. A filtragem continua pertencendo ao
/// controller/consumidor; este widget não cria busca global nem regra própria.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.onClear,
    this.semanticLabel,
  });

  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final VoidCallback? onClear;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: semanticLabel ?? hintText,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        enabled: enabled,
        textInputAction: TextInputAction.search,
        autocorrect: false,
        enableSuggestions: true,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(AppIcons.search),
          suffixIcon: onClear == null
              ? null
              : IconButton(
                  tooltip: 'Limpar busca',
                  onPressed: onClear,
                  icon: const Icon(AppIcons.close),
                ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
