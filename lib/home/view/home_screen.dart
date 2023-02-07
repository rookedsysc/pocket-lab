import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:pocket_lab/goal/component/goal_section.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/home/component/home_screen/wallet_card_slider.dart';
import 'package:pocket_lab/home/component/home_screen/wallet_section.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        body: CupertinoPageScaffold(

          child: SafeArea(
            top: true,
            child: SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ///# Total Balance
                    _totalBalance(textTheme, context),

                    ///# 목표 Section
                    Padding(
                      padding: const EdgeInsets.only(
                          right: 16.0, left: 16.0, bottom: 16.0),
                      child: Center(child: GoalSection()),
                    ),

                    ///# 예산 목록 Section
                    WalletSection(iconTheme: Theme.of(context).iconTheme),
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

  Padding _totalBalance(TextTheme textTheme, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
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
    );
  }

  Padding _padding({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16.0),
      child: child,
    );
  }
}

