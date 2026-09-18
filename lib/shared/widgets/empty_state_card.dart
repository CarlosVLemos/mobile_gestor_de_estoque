import 'package:flutter/widgets.dart';

import 'app_state_panel.dart';

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    super.key,
    required this.title,
    required this.message,
    this.action,
  });

  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return AppStatePanel(
      tone: AppStatePanelTone.empty,
      title: title,
      message: message,
      action: action,
    );
  }
}
