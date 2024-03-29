import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:pocket_lab/home/component/menu_screen/wallet_tile.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/provider/budget_type_provider.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/home/view/menu_screen/wallet_config_screen.dart';

class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _walletHeader(context, ref),
            ),
            _walletListStreamBuilder(ref)
          ],
        ),
      ),
    );
  }

  StreamBuilder<List<Wallet>> _walletListStreamBuilder(WidgetRef ref) {
    return StreamBuilder<List<Wallet>>(
        stream:
            ref.watch(walletRepositoryProvider.notifier).getAllWalletsStream(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final wallets = snapshot.data!;

          return Expanded(
              child: ListView.builder(
                  itemBuilder: ((context, index) {
                    return WalletTile(wallet: wallets[index]);
                  }),
                  itemCount: wallets.length));
        });
  }

  Row _walletHeader(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        HeaderCollection(
          headerType: HeaderType.wallet,
        ),
        IconButton(
          onPressed: () {
            ref
                .read(budgetTypeProvider.notifier)
                .setBudgetType(BudgetType.dontSet);
            CupertinoScaffold.showCupertinoModalBottomSheet(
              context: context,
              builder: (context) {
                return WalletConfigScreen(
                  isEdit: false,
                );
              },
            );
          },
          icon: Icon(
            Icons.add,
            color: Theme.of(context).iconTheme.color,
          ),
        )
      ],
    );
  }
}
