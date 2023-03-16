import 'package:riverpod/riverpod.dart';

final chartTypeProvider = StateProvider<int>((ref) {
  return 0;
});

enum ChartSegmentType{
  trendChart,
  categoryChart,
  categoryTrendChart,
  timeChart,
}