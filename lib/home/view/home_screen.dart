import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:pocket_lab/chart/component/category_chart.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:pocket_lab/goal/component/goal_section.dart';
import 'package:pocket_lab/home/component/home_screen/home_card_chart.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/home/component/home_screen/wallet_card_slider.dart';
import 'package:pocket_lab/home/component/home_screen/wallet_section.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/home/view/drawer_screen.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomeScreen extends ConsumerWidget {
  static const routeName = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        appBar: _appBar(Theme.of(context), ref),
        body: CupertinoPageScaffold(
          child: SafeArea(
            top: true,
            child: SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CategoryChart(isHome: true,)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(ThemeData theme, WidgetRef ref) {
    final zoomDrawerController = ref.read(zoomDrawerControllerProvider);
    return AppBar(
      leading: IconButton(
        onPressed: () => zoomDrawerController.toggle!(),
        icon: Icon(Icons.wallet_outlined, color: theme.iconTheme.color),
      ),
      title: Text(
        'Pocket Lab',
        style: theme.textTheme.bodyLarge,
      ),
      centerTitle: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0.0,
    );
  }
}





