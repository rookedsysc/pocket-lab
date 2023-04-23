import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/chart/model/category_trend_date_standard_model.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';

final categoryTrendDateStandardProvider = StateNotifierProvider<
    CategoryTrendDateStandardNotifier, CateogryTrendDateStandardModel>((ref) {
  return CategoryTrendDateStandardNotifier(ref: ref);
});

class CategoryTrendDateStandardNotifier
    extends StateNotifier<CateogryTrendDateStandardModel> {
  CategoryTrendDateStandardNotifier({required this.ref})
      : super(CateogryTrendDateStandardModel());
  Ref ref;

  Future<void> sync() async {
    final Isar isar = await ref.read(isarProvieder.future);
    final CateogryTrendDateStandardModel? dateStandard =
        await isar.cateogryTrendDateStandardModels.where().findFirst();
    if (dateStandard == null) {
      await isar.writeTxn(() async {
        await isar.cateogryTrendDateStandardModels
            .put(CateogryTrendDateStandardModel());
      });
      state = CateogryTrendDateStandardModel();
    } else {
      state.firstDate = dateStandard.firstDate;
      state.lastDate = dateStandard.lastDate;
    }
  }

  Future<void> setFirstDate(DateTime date) async {
    final isar = await ref.read(isarProvieder.future);
    await sync();
    state.firstDate = date;
    await isar.writeTxn(() async {
      // 현재 state에 해당하는 Id의 데이터의 firstDate를 변경
      await isar.cateogryTrendDateStandardModels.put(state);
    });
  }

  Future<void> setLastDate(DateTime date) async {
    final isar = await ref.read(isarProvieder.future);
    await sync();
    state.lastDate = date;
    await isar.writeTxn(() async {
      // 현재 state에 해당하는 Id의 데이터의 firstDate를 변경
      await isar.cateogryTrendDateStandardModels.put(state);
    });
  }
}
