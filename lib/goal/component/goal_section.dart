import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/goal/component/modal_fit.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/goal/view/goal_screen.dart';
import 'package:sheet/route.dart';
import 'package:sheet/sheet.dart';

class GoalSection extends ConsumerStatefulWidget {
  const GoalSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoalHeaderState();
}

class _GoalHeaderState extends ConsumerState<GoalSection> {
  @override
  Widget build(BuildContext context) {
    final goalsFuture = ref.watch(goalRepositoryProvider);
    return goalsFuture.maybeWhen(data: (goalRepository) {
      return StreamBuilder<List<Goal>>(
          stream: goalRepository.getAllGoals(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HeaderCollection(headerType: HeaderType.goal),
                const SizedBox(
                  height: 8.0,
                ),
                ///# 목표가 있을 때 / 목표가 없을 때 => _goalContainer
                _goalGestureDetector(goals: snapshot.data!)
              ],
            );
          });
    }, orElse: () {
      return Center(child: CircularProgressIndicator());
    });
  }

  //# 있을 때나 없을 때나 같은 디자인
  Widget _goalGestureDetector({required List<Goal> goals}) {
    return GestureDetector(
      onTap: () => CupertinoScaffold.showCupertinoModalBottomSheet(context: context, builder: (context) => GoalScreen()),
      // Navigator.of(context).push(
      //   CupertinoSheetRoute(
      //     initialStop: 0.6,
      //     stops: <double>[0, 0.6, 1],
      //     // Screen은 이동할 스크린
      //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      //     builder: (context) => GoalScreen(),
      //   ),
      // ),
      child: goals.isEmpty
          ? _isEmptyContainer()
          : Badge(
              label: Text(goals.length.toString()),
              child: _isNotEmptyContainer(
                goal: goals[0],
                //# 총 목표 금액 입력
                totalAmount: CustomNumberUtils.formatCurrency(
                    goals.fold<double>(
                        0,
                        (previousValue, element) =>
                            previousValue + element.amount)),
              ),
            ),
    );
  }

  GestureTapCallback _onTap() {
    return () => CupertinoScaffold.showCupertinoModalBottomSheet(context: context, builder: (context) => GoalScreen());
  }

  Widget _isEmptyContainer() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor),
      child: Center(
        child: Text(
          "Set a goal".tr(),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500, fontSize: 16.0),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _isNotEmptyContainer(
      {required Goal goal, required String totalAmount /*목표 총 금액*/}) {
    return Container(
              height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              goal.name,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
              "Total: $totalAmount",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
