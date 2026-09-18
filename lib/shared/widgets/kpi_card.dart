import 'package:flutter/material.dart';

import 'app_metric_card.dart';

enum KpiTone { neutral, positive, warning, critical, restricted }

class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.subtitle,
    this.tone = KpiTone.neutral,
  });

  final String label;
  final String? value;
  final String? subtitle;
  final KpiTone tone;

  @override
  Widget build(BuildContext context) {
    return AppMetricCard(
      label: label,
      value: value,
      subtitle: subtitle,
      tone: switch (tone) {
        KpiTone.neutral => AppMetricTone.neutral,
        KpiTone.positive => AppMetricTone.positive,
        KpiTone.warning => AppMetricTone.warning,
        KpiTone.critical => AppMetricTone.critical,
        KpiTone.restricted => AppMetricTone.restricted,
      },
      emphasis: AppMetricEmphasis.primary,
    );
  }
}
