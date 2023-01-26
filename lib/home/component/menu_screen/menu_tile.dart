import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/view/drawer_screen.dart';

class MenuTile extends ConsumerWidget {
  final Wallet wallet;
  const MenuTile ({ required this.wallet,super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zoomDrawerController = ref.watch(zoomDrawerControllerProvider);
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, "/budget");
        zoomDrawerController.toggle!();
      },
      child: Container(
          height: 50,
          color: Theme.of(context).cardColor,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Image.asset(
                  wallet.imgAddr,
                  height: 30,
                  width: 30,
                ),
              ),
              Text(
                wallet.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                wallet.budget.amount.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          )),
    );
  }
}