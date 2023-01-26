import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';

final walletProvider = ChangeNotifierProvider<WalletRepository>((ref) {
  return WalletRepository(ref);
});

class WalletRepository extends ChangeNotifier {
  final Ref ref;
  List<Wallet> wallets = [];
  int selectedIndex = 0;
  
  WalletRepository(this.ref) {
    getAllWallets();
  }

  getAllWallets() async {
    final isar = await ref.read(isarProvieder.future);
    wallets = await isar.wallets.where().findAll();
  }

  addWallet(Wallet wallet) async {
    final isar = await ref.read(isarProvieder.future);
    await isar.writeTxn(() async {
      await isar.wallets.put(wallet);
    });
    wallets.add(wallet);

    //# 이 클래스의 wallets list가 변했다는 것을 알려줌
    notifyListeners();
  }
}

