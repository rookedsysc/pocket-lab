import 'dart:ffi';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';

final goalProvider = FutureProvider<GoalRepository>((ref) async {
  final isar = ref.watch(isarProvieder.future);
  return GoalRepository(await isar);
});

class GoalRepository {
  final Isar isar;
  GoalRepository(this.isar);

  //# 모든 목표
  Stream<List<Goal>> getAllGoals() {
    return isar.goals.where().watch(fireImmediately: true).asBroadcastStream();
  }

  //# 목표 추가
  Future<void> addGoal(Goal goal) async {
    isar.writeTxn(() async {
      await isar.goals.put(goal);
    });
  }

  //# 목표 수정
  Future<void> updateGoal(Goal goal) async {
    await isar.writeTxnSync(() async {
      await isar.goals.put(goal);
    });
  }

  //# 목표 삭제
  Future<void> deleteGoal(Goal goal) async {
    await isar.goals.delete(goal.id);
  }
}
