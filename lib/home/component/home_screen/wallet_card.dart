import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pocket_lab/common/component/budget_icon_and_name.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/home/component/home_screen/home_card_chart.dart';

class WalletCard extends StatelessWidget {
  //: 예산 이름
  final String name;
  //: 예산 주기
  String? period;
  //: 계좌 잔액
  final double balance;
  //: 예산 금액
  double? amount;
  //: 예산 아이콘 image 주소
  final String imgAddr;
  //: wallet id
  final int walletId;

  WalletCard(
      {required this.imgAddr,
      required this.name,
      required this.balance,
      required this.walletId,
      this.period,
      this.amount,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            HomeCardChart(walletId: walletId, isHome: true,),
            Padding(
            padding: const EdgeInsets.only(
                right: 24.0, left: 24.0, top: 36.0, bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  BudgetIconAndName(imgAddr: imgAddr, name: name),
                  SizedBox(
                    height: 16.0,
                  ),
                
                  //: budget 주기
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CustomNumberUtils.formatCurrency(balance),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(fontSize: 30),
                        ),
                        if (period != null)
                          Text(
                            period!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        //: budget 금액
                        if (amount != null)
                          Text(
                            amount.toString(),
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                            textAlign: TextAlign.end,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
