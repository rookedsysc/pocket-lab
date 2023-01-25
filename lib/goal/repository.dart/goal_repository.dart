


import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';

final isarProvieder = FutureProvider<Isar>((ref) async {
  final isar = await Isar.open([GoalSchema, WalletSchema]);
  return isar;
});

class GoalRepository {
  final WidgetRef ref; 
  GoalRepository(this.ref);
  
  //# 목표 추가
  Future<void> addGoal(Goal goal) async {
    final isar = ref.watch(isarProvieder);
    isar.when(
        data: ((data) {
          data.writeTxn(() async {
            await data.goals.put(goal);
          });
        }),
        error: (error, stackTrace) {},
        loading: (() {}));
  }

  //# 특정 목표 가져오기
  Future<Goal> getGoal(int id) async {
    final isar = await ref.read(isarProvieder.future);
    final goal = await isar.goals.get(id);
    return goal!;
  }

  //# 모든 목표 가져오기
  Stream<List<Goal>> getAllGoals() async* {
    final isar = await ref.watch(isarProvieder.future);
    final allGoals = await isar.goals.where().findAll();
    yield allGoals;
  }

  //# 목표 수정
  Future<void> updateGoal(Goal goal) async {
    final isar = await ref.read(isarProvieder.future);
    await isar.writeTxnSync(() async {
      await isar.goals.put(goal);
    });
  }

  //# 목표 삭제 
  Future<void> deleteGoal(Goal goal) async {
    final isar = await ref.read(isarProvieder.future);
    await isar.goals.delete(goal.id);
  }

  
}
