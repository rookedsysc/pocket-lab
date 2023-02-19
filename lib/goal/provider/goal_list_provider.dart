import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';


//* 로컬에서 목표 리스트
//: modal bottom sheet에서 Stream을 사용할 수 없어서 사용
final goalLocalListProvider = StateNotifierProvider<GoalLocalListNotifier,List<Goal>>((ref) {
  return GoalLocalListNotifier();
});

class GoalLocalListNotifier extends StateNotifier<List<Goal>> {
  GoalLocalListNotifier(): super([]);

  void addGoal(Goal goals) {
    state.add(goals);
  }

  void addGoals(List<Goal> goals) {
    state.addAll(goals);
  }

  void deleteGoal(Goal goal) {
    state = state.where((element) => element.id != goal.id).toList();
  }
}