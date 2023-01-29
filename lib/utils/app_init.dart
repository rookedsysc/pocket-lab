import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';

class AppInit {
  static Future<void> init(WidgetRef ref) async {
    final walletRepository = await ref.read(walletRepositoryProvider.future);

    if(await walletRepository.isEmty()) {
      await walletRepository.configWallet(Wallet(name: "Default",isSelected: true,budget: BudgetModel()));
    }
  }
}