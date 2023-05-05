import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:pocket_lab/common/provider/isar_provider.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';

// final categoryRepositoryProvider =
//     FutureProvider<CategoryRepository>((ref) async {
//   final isar = ref.watch(isarProvieder.future);
//   return CategoryRepository(await isar);
// });

final categoryRepositoryProvider =
    StateNotifierProvider<CategoryRepository, List<TransactionCategory>>((ref) {
  return CategoryRepository(ref);
});

class CategoryRepository extends StateNotifier<List<TransactionCategory>> {
  final Ref ref;
  CategoryRepository(this.ref)
      : super([TransactionCategory(name: "", color: "##000000")]);

  //# 모든 카테고리
  Stream<List<TransactionCategory>> allCategoriesStream() async* {
    final isar = await ref.read(isarProvieder.future);

    yield* isar.transactionCategorys
        .where()
        .watch(fireImmediately: true)
        .asBroadcastStream();
  }

  //# 모든 카테고리
  Future<List<TransactionCategory>> getAllCategories() async {
    final isar = await ref.read(isarProvieder.future);
    return isar.transactionCategorys.where().findAll();
  }

  //# 카테고리 추가
  Future<void> configCategory(TransactionCategory category) async {
    final Isar isar = await ref.read(isarProvieder.future);
    int order = await _getNextOrder();
    category.order = order;
    
    isar.writeTxn(() async {
      await isar.transactionCategorys.put(category);
    });
    syncCategoryCache();
  }

  //: Category 추가할 때 다음 순서를 가져옴
  Future<int> _getNextOrder() async {
    List<TransactionCategory> categories = await getAllCategories();

    if(categories.isEmpty) return 0;

    categories.sort((a, b) => a.order.compareTo(b.order));
    return categories.last.order + 1;
  }

  ///# category id로 카테고리 가져오기
  Future<TransactionCategory?> getCategoryById(int id) async {
    final Isar isar = await ref.read(isarProvieder.future);
    return isar.transactionCategorys.get(id);
  }

  //# 카테고리 삭제
  Future<void> deleteCategory(TransactionCategory category) async {
    final Isar isar = await ref.read(isarProvieder.future);

    isar.writeTxn(() async {
      await isar.transactionCategorys.delete(category.id);
    });
    syncCategoryCache();
  }

  //# DB <===> Local Cache 동기화
  Future<void> syncCategoryCache() async {
    //DB에 있는 모든 카테고리 현재 state와 연동
    final isar = await ref.read(isarProvieder.future);
    // 모든 카테고리 불러오기
    state = await isar.transactionCategorys.where().findAll();
  }
}
