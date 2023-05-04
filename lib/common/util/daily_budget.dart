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

//* 각 Wallet의 예산 설정에 따라 하루 예산을 Wallet의 Balance에 추가해주는 Class -> 프로시저
// a 예산 설정일 때 a 행동
// b 예산 설정일 때 b 행동
//! Class 명이 잘못됐음 GetDailyBudget -> AddDailyBudget
//! 외부에서 호출하지 않는 메서드들은 Private로 변경
//: 프로퍼티가 없는 클래스를 유틸리티 혹은 헬퍼 클래스라고 부름

//# 각 메서드가 하나의 역할을 하는가
//# wallet.budget..... 참조형식 변경
//# WidgetRef 없이 구성없이 사용할 수 있도록 변경
class DailyBudget {
  DailyBudget();

  //* 이 클래스의 메인로직, 모든 Wallet을 불러와서 반복하는 로직
  //: Wallet 마다 예산 설정이 다 다른데 그 다른 예산 설정별로 분기처리를 해주고 있음
  Future<void> add(WidgetRef ref) async {
    List<Wallet> wallets =
        await ref.read(walletRepositoryProvider.notifier).getAllWalletsFuture();
    //# 모든 wallets을 반복
    for (Wallet wallet in wallets) {
      await ref.read(trendRepositoryProvider.notifier)
          .syncTrend(wallet.id);
      if (wallet.budgetType == BudgetType.dontSet) {
        continue;
      } else if (wallet.budgetType == BudgetType.perSpecificDate && wallet.budget.isExist) {
        DateTime? _lastDailyBudgetDate = (await ref
                .read(transactionRepositoryProvider.notifier)
                .getLastDailyBudgetByWalletId(wallet))
            ?.date;
            
        double _dailyBudgetAmount = await _getSecificDateBudget(
            _lastDailyBudgetDate,
            budget: wallet.budget,
            ref: ref);
        await _addTodayBudget(
            wallet: wallet, amount: _dailyBudgetAmount, ref: ref);

        continue;
      }
      final double _budgetAmount =
          await _getBudgetAmount(wallet: wallet, ref: ref);
      //: 해당 wallet이 dontSet 모드 인 경우

      //: 입력할 예산이 없는 경우 loop를 빠져나감
      if (_budgetAmount == 0 || _budgetAmount.isNaN) {
        continue;
      }
      await _addTodayBudget(
          wallet: wallet, amount: _budgetAmount, ref: ref);
      debugPrint("""GetDailyBudget Calss : \n\n
      Wallet: ${wallet.name} \n
      Budget Amount: $_budgetAmount \n
      """);
    }
  }

  //* 특정 일자에 반복되는 예산일 경우 예산 구하기
  //refactor : -> 특정 일자에 반복되는 예산 구하기 (조건이 빠짐)
  Future<double> _getSecificDateBudget(DateTime? lastDailyBudgetDate,
      {required BudgetModel budget, required WidgetRef ref}) async {
    double _dailyBudgetAmount = 0;

    do {
      //: 현재 wallet의 예산일
      final DateTime _budgetDate = budget.budgetDate!;
      //: 최초 예산 입력인 경우
      if (lastDailyBudgetDate == null) {
        //: 최초 예산인데 오늘 날짜가 예산만료일보다 이전인 경우
        if (DateTime.now().isBefore(_budgetDate)) {
          int _diffDays =
              CustomDateUtils().diffDays(budget.budgetDate!, DateTime.now());

          _dailyBudgetAmount += budget.balance! / _diffDays;
          budget.balance = budget.balance! - budget.balance! / _diffDays;

          lastDailyBudgetDate = DateTime.now();
        }
        //: 최초 예산인데 오늘 날짜가 예산일과 같거나 큰 경우
        else {
          budget.budgetDate = CustomDateUtils()
              .getNextBugdetDate(_budgetDate, budget.originDay!);
        }
      }

      //: 오늘 날짜가 예산일보다 이후인 경우
      //: 남은 예산 전부를 넣어주고
      //: 해당 예산을 초기화 해줌
      else if (DateTime.now().isAfter(_budgetDate)) {
        _dailyBudgetAmount += budget.balance!;
        //: 초기화
        budget.budgetDate =
            CustomDateUtils().getNextBugdetDate(_budgetDate, budget.originDay!);
        budget.balance = budget.originBalance;
      }
      //: 오늘 날짜가 예산일보다 이전인 경우
      else {
        //: 마지막 예산일과 오늘 날짜의 차이
        final int _diffDays =
            CustomDateUtils().diffDays(_budgetDate, DateTime.now());
        //: 마지막 예산일 ~ 오늘 날짜까지의 예산을 더해줌
        _dailyBudgetAmount += budget.balance! / _diffDays;
        budget.balance = budget.balance! - budget.balance! / _diffDays;
      }
    } while (lastDailyBudgetDate == null ||
        CustomDateUtils().isBeforeDay(lastDailyBudgetDate, DateTime.now()));

    //! 이거 뭐지
    // if (_dailyBudgetAmount == 0) {
    //   return;
    // }

    return _dailyBudgetAmount;
  }

  //# 얼마의 예산을 넣을지 계산
  Future<double> _getBudgetAmount(
      {required Wallet wallet, required WidgetRef ref}) async {
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
  Future<void> _addTodayBudget(
      {required Wallet wallet,
      required double amount,
      required WidgetRef ref}) async {
    wallet.balance += amount;
    await ref.read(transactionRepositoryProvider.notifier).configTransaction(
        Transaction(
            transactionType: TransactionType.income,
            categoryId: null,
            amount: amount,
            date: DateTime.now(),
            title: dailyBudget,
            walletId: wallet.id));

    await ref.read(walletRepositoryProvider.notifier).configWallet(wallet);
  }
}