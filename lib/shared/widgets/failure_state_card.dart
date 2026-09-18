import 'package:flutter/widgets.dart';

import 'app_state_panel.dart';

class FailureStateCard extends StatelessWidget {
  const FailureStateCard({
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
      tone: AppStatePanelTone.failure,
      title: title,
      message: message,
      action: action,
    );
  }
}
