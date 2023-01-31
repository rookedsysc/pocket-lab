import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';

// final categoryRepositoryProvider =
//     FutureProvider<CategoryRepository>((ref) async {
//   final isar = ref.watch(isarProvieder.future);
//   return CategoryRepository(await isar);
// });

final categoryRepositoryProvider = StateNotifierProvider<CategoryRepository, TransactionCategory>((ref) {
  return CategoryRepository(ref);
});

class CategoryRepository extends StateNotifier<TransactionCategory>{
  final Ref ref;
  CategoryRepository(this.ref): super(TransactionCategory(name: "", color: "##000000"));

  //# 모든 카테고리
  Stream<List<TransactionCategory>> getAllCategories() async* {
    final isar = await ref.read(isarProvieder.future);

    yield* isar.transactionCategorys
        .where()
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }

  //# 카테고리 추가
  Future<void> configCategory(TransactionCategory category) async {
    final Isar isar = await ref.read(isarProvieder.future);
    isar.writeTxn(() async {
      await isar.transactionCategorys.put(category);
    });
  }

  //# 카테고리 삭제
  Future<void> deleteCategory(TransactionCategory category) async {
    final Isar isar = await ref.read(isarProvieder.future);
    isar.writeTxn(() async {
      await isar.transactionCategorys.delete(category.id);
    });
  }
}
