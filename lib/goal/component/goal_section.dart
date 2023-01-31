import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
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
    return goalsFuture.maybeWhen(
      data: (goalRepository) {

      return StreamBuilder<List<Goal>>(
          stream: goalRepository.getAllGoals(),
          builder: (context, snapshot) {

            if(snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HeaderCollection(headerType: HeaderType.goal),
                const SizedBox(
                  height: 8.0,
                ),
                //# 목표가 있을 때 / 목표가 없을 때 => _goalContainer
                _goalContainer(goals: snapshot.data!)
              ],
            );
          });
    }, orElse: () {
      return Center(child: CircularProgressIndicator());
    });
  }

  //# 있을 때나 없을 때나 같은 디자인
  Widget _goalContainer({required List<Goal> goals}) {
    debugPrint("goalSection : $goals");

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        CupertinoSheetRoute(
          initialStop: 0.6,
          stops: <double>[0, 0.6, 1],
            // Screen은 이동할 스크린
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            builder: (context) => GoalScreen(),
          ),
        ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor),
        child: goals.isEmpty ? _isEmptyContainer() : _isNotEmptyContainer(
          goal: goals[0],
          count: goals.length,
        ),
      ),
    );
  }

  GestureTapCallback _onTap() {
    return () => Navigator.of(context).push(
          CupertinoSheetRoute<void>(
            initialStop: 0.6,
            stops: <double>[0, 0.6, 1],
            // Screen은 이동할 스크린
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            builder: (BuildContext context) => GoalScreen(),
          ),
        );
  }

  Center _isEmptyContainer() {
    return Center(
      child: Text(
        "목표를 설정해주세요.",
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _isNotEmptyContainer({required Goal goal, required int count/*목표 개수*/}) {
    return Padding(
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
            count.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
