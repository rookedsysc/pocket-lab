


import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';

final goalIsarProvider = Provider<Future<Isar>>((ref) async {
  final isar = await Isar.open([GoalSchema]);
  return isar;
});