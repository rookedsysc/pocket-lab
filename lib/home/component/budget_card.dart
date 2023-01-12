import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BudgetCard extends StatelessWidget {
  //: 예산 이름
  final String name;
  //: 예산 주기
  final String period;
  //: 예산 금액
  final int amount;

  const BudgetCard(
      {required this.name,
      required this.period,
      required this.amount,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          right: 36.0, left: 24.0, top: 36.0, bottom: 24.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //: budget 이름 
          Text(
            name,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w900),
            textAlign: TextAlign.left,
          ),
          //: budget 주기 
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  period,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.end,
                ),
                //: budget 금액
                Text(
                  amount.toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.end,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
