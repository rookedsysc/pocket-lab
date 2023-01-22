import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';



class GoalScreen extends ConsumerStatefulWidget {
  static const routeName = 'goal_screen';
  const GoalScreen({super.key});

  @override
  ConsumerState<GoalScreen> createState() => _GoalDetailViewState();
}

class _GoalDetailViewState extends ConsumerState<GoalScreen> {
  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //: 그림자 제거
        elevation: 0,

        title: Text("목표 설정",style: Theme.of(context).textTheme.bodyText1,),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        child: goals.length == 0 ? Text("설정된 목표가 없습니다.") : ListView.builder(
          itemBuilder: (context, index) => ListTile(
            title: Text(goals[index].name),
            subtitle: Text(goals[index].firstDate.toString()),
            trailing: Text(goals[index].amount.toString()),
          ),
          itemCount: goals.length,
          ),
        ),
      ),
    );
  }
}
