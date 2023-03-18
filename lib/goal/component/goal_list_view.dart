import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/custom_slidable.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/goal/component/goal_chart.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/provider/goal_list_provider.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/goal/view/goal_config_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GoalListView extends ConsumerStatefulWidget {
  const GoalListView({super.key});

  @override
  ConsumerState<GoalListView> createState() => _GoalListViewState();
}

class _GoalListViewState extends ConsumerState<GoalListView> {
  List<Goal> goals = [];
  late StreamSubscription goalStreamSubscription;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    getGoalList();
  }

  @override
  void dispose() {
    goalStreamSubscription.cancel();
    super.dispose();
  }

  Future<void> getGoalList() async {
    final goalRepository = await ref.read(goalRepositoryProvider.future);
    goalStreamSubscription = goalRepository.getAllGoals().listen((event) {
      if (mounted) {
        goals = event;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
                decoration: _boxDecoration(context),
                child: _slidable(
                    goals: goals,
                    index: index,
                    ref: ref,
                    child: _listTile(goals, index)),
              );
            },
            itemCount: goals.length,
          );
  }

  BoxDecoration _boxDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(8),
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
          showModalBottomSheet(
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

  Widget _listTile(List<Goal> goals, int index) {
    final TextTheme textStyle = Theme.of(context).textTheme;
    return ExpansionTile(
      ///* 버튼 오른쪽이 아닌 왼쪽에 배치
      // controlAffinity: ListTileControlAffinity.leading,
      collapsedTextColor: Theme.of(context).textTheme.bodyMedium?.color,
      collapsedIconColor: Theme.of(context).textTheme.bodyMedium?.color,
      tilePadding: null,
      childrenPadding: null,
      title: ListTile(
        title: Text(
          goals[index].name,
          style: textStyle.bodyMedium,
        ),
        subtitle: Text(
          "Created At ${CustomDateUtils().dateToFyyyyMMdd(goals[index].firstDate)}",
          style: textStyle.bodySmall?.copyWith(color: Colors.grey),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(CustomNumberUtils.formatCurrency(goals[index].amount)),
      ),
      children: [
        GoalChart(goalAmount: goals[index].amount)
      ],
    );
  }
}
