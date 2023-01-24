


import 'dart:ffi';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';

final goalIsarProvider = FutureProvider<Isar>((ref) async {
  final isar = await Isar.open([GoalSchema]);
  return isar;
});

class GoalRepository {
  final WidgetRef ref; 
  GoalRepository(this.ref);
  
  //# 목표 추가
  Future<void> addGoal(Goal goal) async {
    final isar = ref.watch(goalIsarProvider);
    isar.when(
        data: ((data) {
          data.writeTxn(() async {
            await data.goals.put(goal);
          });
        }),
        error: (error, stackTrace) {},
        loading: (() {}));
  }

  //# 목표 선택
  Future<Goal> getGoal(int id) async {
    final isar = await ref.read(goalIsarProvider.future);
    final goal = await isar.goals.get(id);
    return goal!;
  }

  //# 목표 수정
  Future<void> updateGoal(Goal goal) async {
    final isar = await ref.read(goalIsarProvider.future);
    await isar.writeTxnSync(() async {
      await isar.goals.put(goal);
    });
  }

  //# 목표 삭제 
  Future<void> deleteGoal(Goal goal) async {
    final isar = await ref.read(goalIsarProvider.future);
    await isar.goals.delete(goal.id);
  }

  //# 모든 목표 return 
  Stream<List<Goal>> getAllGoals() async* {
    final isar = await ref.watch(goalIsarProvider.future);
    final allGoals = await isar.goals.where().findAll();
    yield allGoals;
  }
}
