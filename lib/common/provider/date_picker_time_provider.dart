import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final datePickerTimeProvider = StateProvider<DateTime>((ref) {
  debugPrint("datePickerTimeProvider");
  return DateTime.now();
});
