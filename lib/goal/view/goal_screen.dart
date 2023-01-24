import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/goal/view/goal_add_modal_screen.dart';
import 'package:sheet/route.dart';

class GoalScreen extends ConsumerStatefulWidget {
  static const routeName = 'goal_screen';
  const GoalScreen({super.key});

  @override
  ConsumerState<GoalScreen> createState() => _GoalDetailViewState();
}

class _GoalDetailViewState extends ConsumerState<GoalScreen> {
  final List<Goal> goals = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    GoalRepository(ref).getAllGoals().listen((event) {
      setState(() {
        goals.clear();
        goals.addAll(event);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //: 그림자 제거
        elevation: 0,

        title: Text(
          "목표 설정",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        actions: [
          //# 추가 버튼
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showMaterialModalBottomSheet(
                  expand: false,
                  context: context,
                  builder: ((context) {
                    return GoalAddModalScreen(
                      height: MediaQuery.of(context).size.height * 0.49,
                      width: MediaQuery.of(context).size.width,
                      textStyle: Theme.of(context).textTheme.bodyText1,
                      cardColor: Theme.of(context).cardColor,
                    );
                  }));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          child: goals.isEmpty
              ? Text("설정된 목표가 없습니다.")
              : ListView.builder(
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
