import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/pending_sale.dart';

final pendingSalesProvider =
    NotifierProvider<PendingSalesController, List<PendingSale>>(
      PendingSalesController.new,
    );

class PendingSalesController extends Notifier<List<PendingSale>> {
  @override
  List<PendingSale> build() => const [];

  void enqueue(PendingSale sale) {
    state = List.unmodifiable([sale, ...state]);
  }
}
