import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/home/component/home_screen/home_card_chart.dart';
import 'package:pocket_lab/home/model/trend_model.dart';
import 'package:pocket_lab/home/model/wallet_model.dart';
import 'package:pocket_lab/home/repository/wallet_repository.dart';
import 'package:riverpod/riverpod.dart';

final trendRepositoryProvider = StateNotifierProvider<TrendRepositoryNotifier, Trend>((ref) {
  return TrendRepositoryNotifier(ref);
});

class TrendRepositoryNotifier extends StateNotifier<Trend> {
  final Ref ref;
  TrendRepositoryNotifier(this.ref): super(Trend(walletId: 0, amount: 0, date: DateTime.now()));

  ///* Home Card Chart Data 가지고 오기
  Stream<List<Trend>> getTrendStream(int walletId) async* {
    final isar = await ref.read(isarProvieder.future);
    yield* isar.trends
        .filter()
        .walletIdEqualTo(walletId)
        .dateGreaterThan(DateTime.now().subtract(Duration(days: 31)))
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }
  

  Future<Trend?> getTodayTrend(int walletId) async {
    final isar = await ref.read(isarProvieder.future);
    DateTime now = DateTime.now();

    final trends = await isar.trends.filter().walletIdEqualTo(walletId).findAll();
    Trend? todayTrend;
    try {
      todayTrend = trends.firstWhere((element) =>
          CustomDateUtils().isSameDay(element.date, DateTime.now()));
    } catch (e) {}

    return todayTrend;
  }

  ///* Wallet의 잔액을 Trend에 저장
  Future<void> syncTrend(int walletId) async {
    final isar = await ref.read(isarProvieder.future);
    ///: 같은 날짜인 데이터에 새로운 데이터 덮어쓰기
    final Trend? trend = await getTodayTrend(walletId);

    ///: trend가 null이면 새로운 데이터 쓰기
    if (trend == null) {
      await isar.writeTxn(() async {
        await isar.trends.put(Trend(walletId: walletId, amount: 0, date: DateTime.now()));
      });

      debugPrint("새로운 Trend 생성");

      return;
    }

    final Wallet? wallet = await ref.read(walletRepositoryProvider.notifier).getSpecificWallet(walletId);
    ///: 선택한 지갑이 없다면 종료
    if(wallet == null) {
      return;
    }

    ///: 선택한 지갑의 현재 잔액을 trend에 최종으로 저장
    trend.amount = wallet.balance;
    trend.date = DateTime.now();

    await isar.writeTxn(() async {
      await isar.trends.put(trend);
    });
  }
}