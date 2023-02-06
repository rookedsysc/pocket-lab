import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/provider/goal_list_provider.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';

class AppInit {
  WidgetRef ref;
  AppInit(this.ref);

  Future<void> main() async {
    await walletInit();
    await syncIsarWithLocalGoalList();
    await categoryInit();
  }

  Future<void> walletInit() async {
    final walletCount =
        await ref.read(walletRepositoryProvider.notifier).getWalletCount();

    if (walletCount == 0) {
      await ref.read(walletRepositoryProvider.notifier).configWallet(
          Wallet(name: "Default", isSelected: true, budget: BudgetModel()));
    }
  }

  Future<void> categoryInit() async {
    final categoryRepository = ref.read(categoryRepositoryProvider.notifier);
    categoryRepository.getAllCategories().listen((event) {
      if (event.isEmpty) {
        categoryRepository.configCategory(TransactionCategory(
            name: "Living Expense", color: "964B00")); //: 갈색
        categoryRepository.configCategory(
            TransactionCategory(name: "Food Expense", color: "0067A3")); //: 파랑
        categoryRepository.configCategory(
            TransactionCategory(name: "Food Expense", color: "ff0000")); //: 빨간색
        categoryRepository.configCategory(
            TransactionCategory(name: "Food Expense", color: "808080")); //: 빨간색
      }
    });
  }

  //: 처음에 시작할 때 db에 있는 목표 목록 불러오기
  Future<void> syncIsarWithLocalGoalList() async {
    final _goalRepositoryProvider =
        await ref.read(goalRepositoryProvider.future);
    List<Goal> goals = await _goalRepositoryProvider.getAllGoalsFuture();
    ref.refresh(goalListProvider.notifier).addGoals(goals);
  }
}
