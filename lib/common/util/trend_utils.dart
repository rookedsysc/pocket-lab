import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrendUtils {
  final WidgetRef ref;
  TrendUtils(this.ref);

  fetchTrend() {
    ref.read(trendRepositoryProvider.notifier).fetchTrend();
  }


}