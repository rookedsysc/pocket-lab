import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pocket_lab/common/component/budget__icon_and_name.dart';

class WalletCard extends StatelessWidget {
  //: 예산 이름
  final String name;
  //: 예산 주기
  final String period;
  //: 예산 금액
  final int amount;
  //: 예산 아이콘 image 주소
  final String imgAddr;

  const WalletCard(
      {required this.imgAddr,
      required this.name,
      required this.period,
      required this.amount,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
          right: 36.0, left: 24.0, top: 36.0, bottom: 24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BudgetIconAndName(imgAddr: "asset/img/bank/금융아이콘_PNG_JP모건체이스.png", name: name),
          
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
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500
                  ),
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