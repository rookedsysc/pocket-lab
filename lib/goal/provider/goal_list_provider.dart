import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';

final goalListProvider = StateNotifierProvider<GoalListNotifier,List<Goal>>((ref) {
  return GoalListNotifier();
});

class GoalListNotifier extends StateNotifier<List<Goal>> {
  GoalListNotifier(): super([]);

  void addGoal(Goal goals) {
    state.add(goals);
  }

  void addGoals(List<Goal> goals) {
    state.addAll(goals);
  }

  void dleteGoal(Goal goal) {
    state = state.where((element) => element.id != goal.id).toList();
  }
}