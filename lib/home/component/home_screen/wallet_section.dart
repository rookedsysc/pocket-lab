import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';

class WalletSection extends ConsumerWidget {
  const WalletSection({
    super.key,
    required this.iconTheme,
  });

  final IconThemeData iconTheme;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<Wallet>>(
      stream: ref.watch(walletRepositoryProvider.notifier).getAllWalletsStream(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return _loadingData(context);
        }

        //# 총 wallet 금액 구하기
          double total = _getTotalWalletAmount(snapshot.data!);

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderCollection(
                  headerType: HeaderType.wallet,
                ),
                Text(
                  "total balance"
                      .tr(args: [CustomNumberUtils.formatCurrency(total)]),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).primaryColor),
                )
              ],
            ),
          );
      }
    );
    
  }

  double _getTotalWalletAmount(List<Wallet> wallets) {
    double total = 0;
    for (var wallet in wallets) {
      total += wallet.balance;
    }
    return total;
  }

  Padding _loadingData(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          HeaderCollection(
            headerType: HeaderType.wallet,
          ),
          Text(
            "Loading data".tr(),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }
}
