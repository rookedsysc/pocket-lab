import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';


final walletProvider = FutureProvider<WalletRepository>((ref) async {
  final isar = await ref.read(isarProvieder.future);
  return WalletRepository(isar: isar);

});

class WalletRepository {
  final Isar isar;
  const WalletRepository({required this.isar});

  //# 모든 지갑 stream
  Stream<List<Wallet>> getAllWallets() {
    return isar.wallets.where().watch(fireImmediately: true).asBroadcastStream();
  }

  //# 지갑 추가
  Future<void> addWallet(Wallet wallet) async {
    await isar.writeTxn(() async {
      await isar.wallets.put(wallet);
    });
  }

  //# 지갑 삭제
  Future<void> deleteWallet(Wallet wallet) async {
    await isar.writeTxn(() async {
      await isar.wallets.delete(wallet.id);
    });
  }

  Future<bool> isEmty() async {
    final walletCount = await isar.wallets.count();
    return walletCount == 0;
  }
}
