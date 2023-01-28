import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';


final walletRepositoryProvider = FutureProvider<WalletRepository>((ref) async {
  final isar = await ref.read(isarProvieder.future);
  return WalletRepository(isar: isar);

});

class WalletRepository {
  final Isar isar;
  const WalletRepository({required this.isar});

  ///# 모든 지갑 stream으로 가져오기 
  Stream<List<Wallet>> getAllWallets() {
    return isar.wallets.where().watch(fireImmediately: true).asBroadcastStream();
  }
  
  ///# 지갑 갯수 가져오기 
  Future<int> getWalletCount() async {
    return await isar.wallets.count();
  }

  ///# 지갑 추가 / 수정
  Future<void> configWallet(Wallet wallet) async {
    await isar.writeTxn(() async {
      await isar.wallets.put(wallet);
    });
  }

  ///# 지갑 삭제
  Future<void> deleteWallet(Wallet wallet) async {
    await isar.writeTxn(() async {
      await isar.wallets.delete(wallet.id);
    });
  }

  ///# 지갑이 비어있는지 확인
  Future<bool> isEmty() async {
    final walletCount = await isar.wallets.count();
    return walletCount == 0;
  }
}
