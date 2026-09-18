import 'package:flutter/widgets.dart';

import 'app_state_panel.dart';

class OfflineStateBanner extends StatelessWidget {
  const OfflineStateBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AppStatePanel(
      tone: AppStatePanelTone.offline,
      message: message,
      layout: AppStatePanelLayout.banner,
    );
  }
}
