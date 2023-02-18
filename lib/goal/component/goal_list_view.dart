import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/custom_slidable.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/goal/component/goal_chart.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/provider/goal_list_provider.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/goal/view/goal_config_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GoalListView extends ConsumerWidget {
  const GoalListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Goal> goals = ref.watch(goalLocalListProvider);
    return goals.length == 0
        ?

        ///# 목표 없을 경우
        Container(
            child: _emtyGoalsView(context),
          )
        :
        ///# 목표 있을 경우
        ListView.builder(
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 4.0),
                //: container 둥글게
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    _slidable(
                        goals: goals,
                        index: index,
                        ref: ref,
                        child: _listTile(goals, index)),
                    GoalChart(
                      goalAmount: goals[index].amount,
                    )
                  ],
                ),
              );
            },
            itemCount: goals.length,
          );
  }

  Text _emtyGoalsView(BuildContext context) {
    return Text(
      "Set a goal".tr(),
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16.0),
      textAlign: TextAlign.center,
    );
  }

  Slidable _slidable(
      {required List<Goal> goals,
      required int index,
      required WidgetRef ref,
      required child}) {
    return Slidable(
      //: 오른쪽에서 왼쪽으로 슬라이드시 발생하는 액션
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        //# 지갑 수정
        SlidableEdit(onPressed: (context) {
          showMaterialModalBottomSheet(
            expand: false,
            context: context,
            builder: ((context) {
              return GoalConfigScreen(
                goal: goals[index],
              );
            }),
          );
        }),
        SlidableDelete(onPressed: (context) async {
          await (await ref.read(goalRepositoryProvider.future))
              .deleteGoal(goals[index]);
          ref.refresh(goalLocalListProvider.notifier).deleteGoal(goals[index]);
        }),
      ]),

      child: child,
    );
  }

  ListTile _listTile(List<Goal> goals, int index) {
    return ListTile(
      title: Text(goals[index].name),
      subtitle: Text(goals[index].firstDate.toString()),
      trailing: Text(CustomNumberUtils.formatCurrency(goals[index].amount)),
    );
  }
}
