import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';

class AppInit {
  static Future<void> init(WidgetRef ref) async {
    final walletRepository = await ref.watch(walletProvider.future);

    if (await walletRepository.isEmpty()) {
      await walletRepository.addWallet(
        Wallet(name: "Default", budget: BudgetModel()),
      );
    }
  }
}
