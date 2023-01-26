import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';

class GoalListView extends ConsumerWidget {
  const GoalListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalFuture = ref.watch(goalProvider);
    return goalFuture.maybeWhen(data: (goalRepository) {
      return StreamBuilder(
          stream: goalRepository.getAllGoals(),
          builder: ((context, snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }
            final goals = snapshot.data;

            return goals == null || goals.isEmpty
                ? Text("설정된 목표가 없습니다.")
                : ListView.builder(
                    itemBuilder: (context, index) => Container(
                      //: container 둥글게
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      child: ListTile(
                        title: Text(goals[index].name),
                        subtitle: Text(goals[index].firstDate.toString()),
                        trailing: Text(goals[index].amount.toString()),
                      ),
                    ),
                    itemCount: goals.length,
                  );
          }));
    }, orElse: (() {
      return Center(child: CircularProgressIndicator());
    }));
  }
}
