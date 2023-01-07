import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pocket_lab/goal/component/goal_header.dart';
import 'package:pocket_lab/home/component/budget_card.dart';
import 'package:pocket_lab/home/component/transaction_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
          child: GoalHeader(),
        ),
        BudgetCard(),
        TransactionButtons(),
      ],
    );
  }
}
