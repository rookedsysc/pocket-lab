import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});
  @override
  Widget build(BuildContext context, ref) {
    final walletsFuture = ref.watch(walletProvider);
    return walletsFuture.maybeWhen(
      data: (walletRepository) {
        final walletsStream = walletRepository.getWalletsStream();

        return Scaffold(
          body: SafeArea(
            top: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    HeaderCollection(
                      headerType: HeaderType.wallet,
                    ),
                    IconButton(
                      onPressed: () {
                        // 랜덤 숫자 생성
                        final randomInt = Random().nextInt(100);
                        walletRepository.addWallet(Wallet(
                            name: "BudgetNumber $randomInt",
                            budget: BudgetModel()));
                      },
                      icon: Icon(
                        Icons.add,
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: StreamBuilder(
                      stream: walletsStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final wallets = snapshot.data!;
                        return ListView.builder(
                          itemBuilder: (context, index) => _menuBudget(
                            wallet: wallets[index],
                            theme: Theme.of(context),
                          ),
                          itemCount: wallets.length,
                        );
                      }),
                )
              ],
            ),
          ),
        );
      },
      orElse: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Container _menuBudget({required Wallet wallet, required ThemeData theme}) {
    return Container(
        height: 50,
        color: theme.cardColor,
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
              style: theme.textTheme.bodyLarge,
            ),
            Text(
              wallet.budget.amount.toString(),
              style: theme.textTheme.bodyLarge,
            ),
          ],
        ));
  }
}
