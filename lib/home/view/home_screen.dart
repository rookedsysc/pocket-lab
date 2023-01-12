import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/goal/component/goal_header.dart';
import 'package:pocket_lab/home/component/budget_card_slider.dart';
import 'package:pocket_lab/home/component/transaction_button.dart';
import 'package:pocket_lab/home/view/budget_screen.dart';

class HomeScreen extends StatelessWidget {  
  static const routeName = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
            child: Row(
              children: [
                Expanded(child: GoalHeader()),
                IconButton(
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: ((context) => BudgetScreen()),
                    );
                  },
                  icon: Icon(Icons.wallet_rounded),
                )
              ],
            ),
          ),
          BudgetCardSlider(),
          TransactionButtons(),
        ],
      ),
    );
  }
}
