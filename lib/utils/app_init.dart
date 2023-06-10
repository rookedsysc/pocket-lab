import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/util/daily_budget.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/provider/goal_list_provider.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';

class AppInit {
  WidgetRef ref;
  AppInit(this.ref);

  Future<void> main() async {
    await _walletInit();
    await _syncIsarWithLocalGoalList();
    await _categoryInit();
    await DailyBudget().add(ref);
    await ref.read(trendRepositoryProvider.notifier).allWalletsSync();
    await ref.read(walletRepositoryProvider.notifier).syncState();
  }

  Future<void> _walletInit() async {
    final walletCount =
        await ref.read(walletRepositoryProvider.notifier).getWalletCount();

    if (walletCount == 0) {
      await ref.read(walletRepositoryProvider.notifier).configWallet(
          Wallet(name: "Default", isSelected: true, budget: BudgetModel()));
      Wallet _wallet = await ref
          .read(walletRepositoryProvider.notifier)
          .getIsSelectedWallet();
      debugPrint("wallet id: ${_wallet.id}");
    }
  }

  Future<void> _categoryInit() async {
    final categoryRepository = ref.read(categoryRepositoryProvider.notifier);
    List<TransactionCategory> categories =
        await categoryRepository.getAllCategories();
    if (categories.isEmpty) {
      await categoryRepository.configCategory(
          category: TransactionCategory(
              name: "init category.unclassified".tr(), color: "D3D3D3"),
          isEdit: false); //: 연한 흰색
      await categoryRepository.configCategory(
          category: TransactionCategory(
              name: "init category.food".tr(), color: "0067A3"),
          isEdit: false); //: 파랑
      await categoryRepository.configCategory(
          category: TransactionCategory(
              name: "init category.hobby".tr(), color: "ff0000"),
          isEdit: false); //: 빨간색
      await categoryRepository.configCategory(
          category: TransactionCategory(
              name: "init category.cost of living".tr(), color: "ffff00"),
          isEdit: false); //: 노란색
      await categoryRepository.configCategory(
          category: TransactionCategory(
              name: "init category.fashion".tr(), color: "800080"),
          isEdit: false); //: 보라색
      await categoryRepository.configCategory(
          category: TransactionCategory(
              name: "init category.study".tr(), color: "008000"),
          isEdit: false); //: 초록색
    }
    ref.read(categoryRepositoryProvider.notifier).syncCategoryCache();
  }

  //: 처음에 시작할 때 db에 있는 목표 목록 불러오기
  Future<void> _syncIsarWithLocalGoalList() async {
    final _goalRepositoryProvider =
        await ref.read(goalRepositoryProvider.future);
    List<Goal> goals = await _goalRepositoryProvider.getAllGoalsFuture();
    ref.refresh(goalLocalListProvider.notifier).addGoals(goals);
  }
}
