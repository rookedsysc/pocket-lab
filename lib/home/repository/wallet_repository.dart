import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';

final walletRepositoryProvider =
    StateNotifierProvider<WalletRepository, Wallet>((ref) {
  return WalletRepository(ref: ref);
});

class WalletRepository extends StateNotifier<Wallet> {
  final Ref ref;
  WalletRepository({required this.ref})
      : super(Wallet(name: "", budget: BudgetModel())) {
        getIsSelectedWallet();
  }

  Future<void> syncState() async {
    final isar = await ref.read(isarProvieder.future);
    state = (await isar.wallets.where().findAll()).first;
  }

  ///# 모든 지갑 stream으로 가져오기
  Stream<List<Wallet>> getAllWalletsStream() async* {
    final isar = await ref.read(isarProvieder.future);
    yield* isar.wallets
        .where()
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }

  ///# 모든 지갑 Future로 가져오기
  Future<List<Wallet>> getAllWalletsFuture() async {
    final isar = await ref.read(isarProvieder.future);
    return isar.wallets.where().findAll();
  }

  ///# 선택한 지갑 가져오기
  Future<Wallet?> getSpecificWallet(int? id) async {
    final isar = await ref.read(isarProvieder.future);
    if (id == null) {
      return await isar.wallets.where().findFirst();
    }
    return await isar.wallets.get(id);
  }

  ///# 지갑 갯수 가져오기
  Future<int> getWalletCount() async {
    final isar = await ref.read(isarProvieder.future);
    return await isar.wallets.count();
  }

  ///# 선택된 지갑 인덱스 가져오기
  int getSelectedWalletIndex(List<Wallet> wallets) {
    int index = 0;
    index = wallets.indexWhere((element) => element.isSelected);
    return index;
  }
  
  ///# isSelected == true인 지갑 가져오기
  Future<Wallet> getIsSelectedWallet() async {
    final Isar isar = await ref.read(isarProvieder.future);
    isar.wallets.where().filter().isSelectedEqualTo(true).findFirst().then((value) {
      if (value != null) {
        state = value;
      }
    });
    return state;
  }

  ///# 첫 번째 지갑 가져오기
  Future<Wallet?> getFirstWallet() async {
    final isar = await ref.read(isarProvieder.future);
    return await isar.wallets.where().findFirst();
  }

  ///# 선택된 지갑 변경
  Future setIsSelectedWallet(int newWalletId) async {
    final isar = await ref.read(isarProvieder.future);
    //: 이전에 선택된 지갑의 isSelected를 false로 변경
    await isar.wallets
        .where()
        .filter()
        .isSelectedEqualTo(true)
        .findFirst()
        .then((value) async {
      await isar.writeTxn(() async {
        if (value != null) {
          value.isSelected = false;
          await isar.wallets.put(value);
          state = value;
        }
      });
    });

    //: 선택된 지갑의 isSelected를 true로 변경
    await getSpecificWallet(newWalletId).then((value) async {
      await isar.writeTxn(() async {
        if (value != null) {
          value.isSelected = true;
          state = value;
          await isar.wallets.put(value);
        }
      });
    });
  }

  ///# 지갑 추가 / 수정
  Future<void> configWallet(Wallet wallet) async {
    final isar = await ref.read(isarProvieder.future);
    await isar.writeTxn(() async {
      await isar.wallets.put(wallet);
    });
  }

  ///# 지갑 삭제
  Future<void> deleteWallet(Wallet wallet) async {
    final isar = await ref.read(isarProvieder.future);

    await isar.writeTxn(() async {
      await isar.wallets.delete(wallet.id);
    });

    await syncState();
  }

  ///# 지갑이 비어있는지 확인
  Future<bool> isEmty() async {
    final isar = await ref.read(isarProvieder.future);
    final walletCount = await isar.wallets.count();
    return walletCount == 0;
  }

  ///# 지갑 id로 지갑 이름 가져오기
  Future<String> getWalletName(int walletId) async {
    final isar = await ref.read(isarProvieder.future);
    final wallet = await isar.wallets.get(walletId);
    return wallet!.name;
  }
}
