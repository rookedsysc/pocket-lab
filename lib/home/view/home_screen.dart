import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/constant/ad_unit_id.dart';
import 'package:pocket_lab/common/provider/payment_status_provider.dart';
import 'package:pocket_lab/common/widget/banner_ad_container.dart';
import 'package:pocket_lab/goal/component/goal_section.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/home/component/home_screen/wallet_card_slider.dart';
import 'package:pocket_lab/home/component/home_screen/wallet_section.dart';
import 'package:pocket_lab/home/view/drawer_screen.dart';
import 'package:pocket_lab/home/view/widget/category_editable_list.dart';
import 'dart:io' show Platform;


class HomeScreen extends ConsumerWidget {
  static const routeName = 'home_screen';
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Scaffold(
        appBar: _appBar(ref, context),
        body: CupertinoPageScaffold(
          child: SafeArea(
            top: true,
            child: Stack(
              children: [
                SingleChildScrollView(
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

                      WalletCardSlider(), TransactionButtons(),


                      Padding(
                        padding: const EdgeInsets.only(
                            right: 16.0, left: 16.0, bottom: 16.0),
                        child: CategoryEditableList(),
                      ),
                      //: banner 높이 
                      if(!ref.watch(paymentStatusProvider))SizedBox(height: 50,)
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BannerAdContainer(
                    adUnitId: Platform.isAndroid
                        ? MAIN_PAGE_BANNER_AOS
                        : MAIN_PAGE_BANNER_IOS,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(WidgetRef ref, BuildContext context) {
    final zoomDrawerController = ref.read(zoomDrawerControllerProvider);
    final theme = Theme.of(context);
    return AppBar(
      actions: [
        // IconButton(
        //     onPressed: () {
        //       CupertinoScaffold.showCupertinoModalBottomSheet(
        //           context: context, builder: (context) => SubscribeScreen());
        //     },
        //     icon: Icon(
        //       Icons.attach_money,
        //       color: theme.iconTheme.color,
        //     ))
      ],
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
