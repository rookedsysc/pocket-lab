import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/provider/goal_list_provider.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';

class GoalListView extends ConsumerWidget {
  const GoalListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Goal> goals = ref.watch(goalListProvider);
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: 4.0),
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
        );
      },
      itemCount: goals.length,
    );
  }
}
