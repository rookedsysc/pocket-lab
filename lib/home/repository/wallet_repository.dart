import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';

final walletProvider = FutureProvider((ref) async {
  final isar = ref.watch(isarProvieder.future);
  return WalletRepository(await isar);
});

class WalletRepository {
  const WalletRepository(this.isar);
  final Isar isar;

  Stream<List<Wallet>> getWalletsStream() {
    return isar.wallets.where().watch(
          fireImmediately: true,
        );
  }

  Future<List<Wallet>> getWallets() async {
    return await isar.wallets.where().findAll();
  }

  addWallet(Wallet wallet) async {
    await isar.writeTxn(() async {
      await isar.wallets.put(wallet);
    });
  }

  Future<bool> isEmpty() async {
    return await isar.wallets.count() == 0;
  }
}
