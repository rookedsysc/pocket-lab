import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/goal/component/goal_header.dart';
import 'package:pocket_lab/home/component/budget_card_slider.dart';
import 'package:pocket_lab/home/component/transaction_button.dart';
import 'package:pocket_lab/home/view/budget_screen.dart';


class HomeScreen extends StatelessWidget {  
  //! global key로 선언하면 동작 안함
  final ZoomDrawerController zoomDrawerController;
  static const routeName = 'home_screen';
  HomeScreen({required this.zoomDrawerController,super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
              child: Stack(
                children: [
                  _drawerButton(),
                  Center(child: GoalHeader()),
                ],
              ),
            ),
            BudgetCardSlider(),
            TransactionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _drawerButton() {
    return IconButton(
      onPressed: () => zoomDrawerController.toggle!(),
      icon: const Icon(Icons.wallet_rounded),
    );
  }
}
