import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/transaction/view/transaction_config_screen.dart';

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
          context: context,
        ),
        // TransactionButton(
        //   transactionType: TransactionType.remittance,
        //   context: context,
        // ),
        TransactionButton(
          transactionType: TransactionType.expenditure,
          context: context,
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
  final BuildContext context;

  TransactionButton(
      {required this.transactionType,
      // required this.budgetId,
      // required this.budgetName,
      required this.context,
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

    return cardButton(
      icon: _icon,
      onPressed: () => CupertinoScaffold.showCupertinoModalBottomSheet(
        context: context,
        builder: (context) {
          return TransactionConfigScreen(
            isEdit: false,
            transactionType: transactionType,
          );
        },
      ),
    );
  }


  Widget cardButton({required Icon icon, required VoidCallback onPressed}) {
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