import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/home/view/budget_detail_screen.dart';
import 'package:pocket_lab/home/view/transaction_screen.dart';

enum TransactionType { remittance, income, expenditure }

class TransactionButtons extends StatelessWidget {
  const TransactionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(
          width: 50.0,
        ),
        TransactionButton(
          transactionType: TransactionType.income,
          ctx: context,
        ),
        TransactionButton(
          transactionType: TransactionType.remittance,
          ctx: context,
        ),
        TransactionButton(
          transactionType: TransactionType.expenditure,
          ctx: context,
        ),
        const SizedBox(
          width: 50.0,
        ),
      ],
    );
  }
}

class TransactionButton extends StatelessWidget {
  // final String budgetId;
  // final String budgetName;
  final TransactionType transactionType;
  final BuildContext ctx;

  TransactionButton(
      {required this.transactionType,
      // required this.budgetId,
      // required this.budgetName,
      required this.ctx,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Icon _icon;

    switch (transactionType) {
      case TransactionType.income:
        _icon = Icon(
          Icons.add,
          color: Colors.green,
        );
        break;
      case TransactionType.expenditure:
        _icon = Icon(
          Icons.remove,
          color: Colors.red,
        );
        break;
      case TransactionType.remittance:
        _icon = Icon(
          Icons.send,
          color: Colors.blue,
        );
        break;
    }

    return CardButton(
      icon: _icon,
      onPressed: () {
        showCupertinoModalBottomSheet(
          elevation: 16.0,
          context: ctx,
          builder: (_) => TransactionScreen(transactionType: transactionType),
        );
      },
    );
  }

  Widget CardButton({required Icon icon, required VoidCallback onPressed}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}