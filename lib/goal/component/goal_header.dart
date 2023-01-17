
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/view/goal_screen.dart';

class GoalHeader extends ConsumerStatefulWidget {
  const GoalHeader({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoalHeaderState();
}

class _GoalHeaderState extends ConsumerState<GoalHeader> {
  @override
  Widget build(BuildContext context) {
    final goals = ref.watch(goalsProvider);

    return SafeArea(
        top: true,
        child: goals.length == 0
            ? GestureDetector(
                onTap: () => showCupertinoModalBottomSheet(
                    context: context,
                    builder: (_) {
                      return GoalScreen();
                    }),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    //: 테두리
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 4),
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).cardColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "목표를 설정해주세요.",
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                itemBuilder: ((context, index) => GestureDetector(
                      onTap: () => showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return GoalScreen();
                          }),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          //: 테두리
                          border: Border.all(color: Colors.green, width: 4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(goals[index].name),
                            // 5000원 > 5,000원
                            Text("${goals[index].amount.toStringAsFixed(0)}원"),
                          ],
                        ),
                      ),
                    )),
                itemCount: goals.length,
                shrinkWrap: true));
  }
}
