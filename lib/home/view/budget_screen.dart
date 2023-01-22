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
      body: Stack(
        fit: StackFit.expand,
        children: [
          budgetList.isEmpty
          ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("예산 목록이 없습니다."),
          )
          : ListView.builder(
              itemBuilder: (context, index) => SizedBox(
                  height: 300,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                      child: WalletCard(
                        name: "Budget ${budgetList[index]}",
                        period: "7일",
                        amount: 50000,
                        imgAddr: '금융아이콘_PNG_토스.png',
                      ),
                    ),
                  ),
                  itemCount: budgetList.length,
                ),
          IconButton(
            alignment: Alignment.topRight,
            onPressed: (){}, icon: Icon(Icons.add), color: Theme.of(context).iconTheme.color,),

        ],
      ),
    );
  }
}