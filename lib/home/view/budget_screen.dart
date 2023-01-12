import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pocket_lab/home/component/budget_card.dart';

class BudgetScreen extends StatelessWidget {
  static const routeName = 'budget_screen';
  const BudgetScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetList = ["1", "2", "3"];
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        //: 그림자 제거
        elevation: 0,

        title: const Text("예산 목록"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
            },
          ),
        ],
      ),
      body: budgetList.length == 0
          ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("예산 목록이 없습니다."),
          )
          : ListView.builder(
              itemBuilder: (context, index) => SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: BudgetCard(
                        name: "Budget ${budgetList[index]}",
                        period: "7일",
                        amount: 50000),
                  )),
              itemCount: budgetList.length,
            ),
    );
  }
}