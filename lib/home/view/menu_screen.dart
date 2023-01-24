import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pocket_lab/common/component/header_collection.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderCollection(headerType: HeaderType.wallet,),
                IconButton(
                  onPressed: () {
                    
                  },
                  icon: Icon(
                    Icons.add,
                  ),
                )

              ],
            ),
            _menuBudget(assetImg: "asset/img/bank/금융아이콘_PNG_카카오뱅크.png",theme: Theme.of(context), color: Colors.green, budgetName: "budget 1", budgetAmount: 2000),
            _menuBudget(assetImg: "asset/img/bank/금융아이콘_PNG_카카오뱅크.png",theme: Theme.of(context), color: Colors.green, budgetName: "budget 2", budgetAmount: 3000),
            _menuBudget(assetImg: "asset/img/bank/금융아이콘_PNG_한화.png",theme: Theme.of(context), color: Colors.green, budgetName: "budget 3", budgetAmount: 10000)
          ],
        ),
      ),
    );
  }
  
  Container _menuBudget({required String assetImg,required ThemeData theme, required Color color, required String budgetName, required int budgetAmount}) {
    return Container(
        height: 50,
        color: color,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0),
              child: Image.asset(assetImg,height: 30,width: 30,),
            ),
            Text(
              budgetName,
              style: theme.textTheme.bodyText1,
            ),
            Text(
              budgetAmount.toString(),
              style: theme.textTheme.bodyText1,
            ),
          ],
        ));
  }
}