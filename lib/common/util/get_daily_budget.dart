import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/constant/daily_budget.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/trend_repository.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';

class GetDailyBudget {
  final WidgetRef ref;
  GetDailyBudget(this.ref);

  Future<void> main() async {
    final wallets =
        await ref.read(walletRepositoryProvider.notifier).getAllWalletsFuture();
    //# 모든 wallets을 반복
    for (int index = 0; index < wallets.length; index++) {
      await ref.read(trendRepositoryProvider.notifier).syncTrend(wallets[index].id);
      if (wallets[index].budgetType == BudgetType.dontSet) {
        continue;
      } else if (wallets[index].budgetType == BudgetType.perSpecificDate) {
        await getSecificDateBudget(wallets[index]);
        continue;
      }
      final double _budgetAmount =
          await getBudgetAmount(wallet: wallets[index]);
      //: 해당 wallet이 dontSet 모드 인 경우

      //: 입력할 예산이 없는 경우 loop를 빠져나감
      if (_budgetAmount == 0 || _budgetAmount.isNaN) {
        continue;
      }

      await addTodayBudget(wallet: wallets[index], amount: _budgetAmount);
      debugPrint("""GetDailyBudget Calss : \n\n
      Wallet: ${wallets[index].name} \n
      Budget Amount: $_budgetAmount \n
      """);
    }
  }

  //* 특정 일자에 반복되는 예산일 경우 예산 구하기
  Future<void> getSecificDateBudget(Wallet wallet) async {
    double _dailyBudgetAmount = 0;
    //: null check
    if (wallet.budget.balance == null ||
        wallet.budget.originBalance == null ||
        wallet.budget.budgetDate == null ||
        wallet.budget.originDay == null) {
      return;
    }
    //: 마지막 입력된 예산
    DateTime? _lastDailyBudgetDate = (await ref
          .read(transactionRepositoryProvider.notifier)
          .getLastDailyBudgetByWalletId(wallet))?.date;

    do {
      //: 현재 wallet의 예산일
      final DateTime _budgetDate = wallet.budget.budgetDate!;
      //: 최초 예산 입력인 경우
      if (_lastDailyBudgetDate == null) {
        //: 최초 예산인데 오늘 날짜가 예산일보다 이전인 경우
        if (DateTime.now().isBefore(_budgetDate)) {
          int _diffDays = CustomDateUtils().diffDays(wallet.budget.budgetDate!, DateTime.now());

          _dailyBudgetAmount += wallet.budget.balance! / _diffDays;
          wallet.budget.balance =
              wallet.budget.balance! - wallet.budget.balance! / _diffDays;

          _lastDailyBudgetDate = DateTime.now();
        }
        //: 최초 예산인데 오늘 날짜가 예산일과 같거나 큰 경우
        else {
          wallet.budget.budgetDate = CustomDateUtils()
              .getNextBugdetDate(_budgetDate, wallet.budget.originDay!);
        }
      }

      //: 오늘 날짜가 예산일보다 이후인 경우
      //: 남은 예산 전부를 넣어주고
      //: 해당 예산을 초기화 해줌
      else if (DateTime.now().isAfter(_budgetDate)) {
        _dailyBudgetAmount += wallet.budget.balance!;
        //: 초기화
        wallet.budget.budgetDate = CustomDateUtils()
            .getNextBugdetDate(_budgetDate, wallet.budget.originDay!);
        wallet.budget.balance = wallet.budget.originBalance;
      }
      //: 오늘 날짜가 예산일보다 이전인 경우
      else {
        //: 마지막 예산일과 오늘 날짜의 차이
        final int _diffDays = CustomDateUtils().diffDays(_budgetDate, DateTime.now());
        //: 마지막 예산일 ~ 오늘 날짜까지의 예산을 더해줌
        _dailyBudgetAmount += wallet.budget.balance! / _diffDays;
        wallet.budget.balance =
            wallet.budget.balance! - wallet.budget.balance! / _diffDays;
      }
    } while (_lastDailyBudgetDate == null || CustomDateUtils().isBeforeDay(_lastDailyBudgetDate, DateTime.now()));
    if (_dailyBudgetAmount == 0) {
      return;
    }

    await addTodayBudget(wallet: wallet, amount: _dailyBudgetAmount);
  }

  //# 얼마의 예산을 넣을지 계산
  Future<double> getBudgetAmount({required Wallet wallet}) async {
    final Transaction? _lastDailyBudget = await ref
        .read(transactionRepositoryProvider.notifier)
        .getLastDailyBudgetByWalletId(wallet);

    //: 하루 예산이 입력되지 않은 일 수
    int noDialyWidgetDays;

    if (_lastDailyBudget == null) {
      noDialyWidgetDays = 1;
    } else {
      //: dailyBudget이 없는 날의 수
      debugPrint(
          "마지막 예산이 입력된 날 : ${CustomDateUtils().stringToDate(_lastDailyBudget.date.toString())}");
      debugPrint("현재 날짜 : ${DateTime.now()}");
      noDialyWidgetDays =
          DateTime.now().difference(_lastDailyBudget.date).inDays;
      debugPrint("Daily 예산이 입력되지 않은 일 수 : ${noDialyWidgetDays.toString()}");
    }

    //: 하루 예산
    if (wallet.budget.balance == null || wallet.budget.budgetPeriod == null) {
      return 0;
    }

    double dailyBudget =
        (wallet.budget.balance! / wallet.budget.budgetPeriod!).toDouble();
    //: 하루 예산 * noDialyWidgetDays
    return dailyBudget * noDialyWidgetDays.toDouble();
  }

  //# 실제 구해진 Daily Budget을 추가하는 함수
  Future<void> addTodayBudget(
      {required Wallet wallet, required double amount}) async {
    wallet.balance += amount;
    await ref.read(transactionRepositoryProvider.notifier).configTransaction(
        Transaction(
            transactionType: TransactionType.income,
            category: null,
            amount: amount,
            date: DateTime.now(),
            title: dailyBudget,
            walletId: wallet.id));
    ref.read(walletRepositoryProvider.notifier).configWallet(wallet);
  }
}
