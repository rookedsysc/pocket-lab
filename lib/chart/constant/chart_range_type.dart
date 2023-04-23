import 'package:riverpod/riverpod.dart';

final chartRangeProvider = StateProvider<ChartRangeType>((ref) {
  return ChartRangeType.daily;
});

enum ChartRangeType{
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
}