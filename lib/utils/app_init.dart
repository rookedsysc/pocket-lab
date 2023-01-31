import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/provider/goal_list_provider.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';

class AppInit {
  WidgetRef ref;
  AppInit(this.ref) {
    init();
    syncIsarWithLocalGoalList();
  }
  Future<void> init() async {
    final walletRepository = await ref.read(walletRepositoryProvider.future);

    if(await walletRepository.isEmty()) {
      await walletRepository.configWallet(Wallet(name: "Default",isSelected: true,budget: BudgetModel()));
    }
  }
  
  //: 처음에 시작할 때 db에 있는 목표 목록 불러오기 
  Future<void> syncIsarWithLocalGoalList() async {
    final _goalRepositoryProvider = await ref.watch(goalRepositoryProvider.future);
    List<Goal> goals = [];
    _goalRepositoryProvider.getAllGoals().listen((event) {
      goals = event;
      ref.refresh(goalListProvider.notifier).addGoals(goals);
    });
  }
}