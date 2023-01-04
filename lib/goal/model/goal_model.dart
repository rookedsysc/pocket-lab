import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:uuid/uuid.dart';

part 'goal_model.g.dart';

final goalsProvider = StateNotifierProvider<GoalListNotifier,List<Goal>>((ref) {
  return GoalListNotifier(ref);
});

class GoalListNotifier extends StateNotifier<List<Goal>> {
  GoalListNotifier(Ref ref) : super([]) {
    syncGoal(ref);
  }

  void syncGoal(Ref ref) async {
    final isar = await ref.read(goalIsarProvider);

    if(await isar.goals.count() > 0) {
      //: 모든 데이터 가져와서 state에 저장 
      state = await isar.goals.where().findAll();
    }
  }
}

@Collection()
class Goal {
  Id id = Isar.autoIncrement;
  final String name;
  final int amount;
  final String firstDate;
  String? lastDate;

  Goal({
    required this.name,
    required this.amount,
    required this.firstDate,
    this.lastDate,
  });
}