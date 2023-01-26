import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:pocket_lab/goal/component/goal_section.dart';
import 'package:pocket_lab/home/component/transaction_button.dart';
import 'package:pocket_lab/home/component/wallet_card_slider.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';

class HomeScreen extends StatelessWidget {
  final ZoomDrawerController zoomDrawerController;
  static const routeName = 'home_screen';
  const HomeScreen({required this.zoomDrawerController, super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      color: Theme.of(context).backgroundColor,
      child: Scaffold(
        body: CupertinoPageScaffold(

          child: SafeArea(
            top: true,
            child: SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //# Total Balance
                    _padding(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          HeaderCollection(headerType: HeaderType.total,),
                          SizedBox(
                            height: 8.0,),
                          Text(
                            "50,000",
                            style: textTheme.bodyMedium
                                ?.copyWith(fontSize: 36.0, fontWeight: FontWeight.w700, color: Theme.of(context).primaryColor),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),

                    //# 목표 Section
                    _padding(child: Center(child: GoalSection())),
                    //# 예산 목록 Section
                    _walletSection(Theme.of(context).iconTheme),
                    SizedBox(
                      height: 8.0,
                    ),
                    WalletCardSlider(),
                    TransactionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding _padding({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
      child: child,
    );
  }

  Padding _walletSection(IconThemeData iconTheme) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
        children: [
          IconButton(
            onPressed: () => zoomDrawerController.toggle!(),
            icon: Icon(Icons.wallet_outlined, color: iconTheme.color),
          ),
          HeaderCollection(
            headerType: HeaderType.wallet,
          ),
        ],
      ),
    );
  }
}
