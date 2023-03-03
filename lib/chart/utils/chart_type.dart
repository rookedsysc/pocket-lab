import 'package:riverpod/riverpod.dart';

final chartSegmentProvider = StateProvider<ChartSegmentType>((ref) {
  return ChartSegmentType.daily;
});

enum ChartSegmentType{
  daily,
  weekly,
  monthly,
  quarterly,
  yearly,
}