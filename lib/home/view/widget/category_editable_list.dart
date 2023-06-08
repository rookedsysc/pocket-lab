
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/home/view/home_screen/category_input_modal_screen.dart';
import 'package:pocket_lab/home/view/widget/color_picker_alert_dialog.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class CategoryEditableList extends ConsumerWidget {
  bool isEdit = false;
  List<TransactionCategory> _categories = [];
  CategoryEditableList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<TransactionCategory>>(
        stream: ref
            .watch(categoryRepositoryProvider.notifier)
            .allCategoriesStream(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: const CircularProgressIndicator(),
            );
          }

          _categories = snapshot.data!;
          _categories.sort((a, b) => a.order.compareTo(b.order));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeaderCollection(headerType: HeaderType.categoryList),
              SizedBox(
                height: 8.0,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                child: ReorderableGridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 5,
                    onReorder: ((oldIndex, newIndex) async {
                      List<TransactionCategory> _temp = _categories;
                      final item = _temp.removeAt(oldIndex);
                      _temp.insert(newIndex, item);
              
                      await ref.read(categoryRepositoryProvider.notifier).reorderCatregory(temp: _temp);
                    }),
                    children: List.generate(_categories.length + 1, (index) {
                      if (index == _categories.length) {
                        return _addItem(context);
                      }
              
                      return _categoryItem(
                          context: context,
                          category: _categories[index],
                          textTheme: Theme.of(context).textTheme.bodyMedium!,
                          ref: ref);
                    })),
              ),
            ],
          );
        });
  }

  Widget _addItem(BuildContext context) {
    return InkWell(
      key: ValueKey("add"),
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return CategoryInputModalScreen(
                isEdit: false,
              );
            });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
            child: Icon(
          Icons.add,
          color: Theme.of(context).textTheme.bodyLarge!.color,
        )),
      ),
    );
  }

  Widget _categoryItem(
      {required TransactionCategory category,
      required TextStyle textTheme,
      required WidgetRef ref,
      required BuildContext context}) {
    Color _textColor = Colors.black;

    if (ColorUtils.isBlackShade(category.color)) {
      _textColor = Colors.white;
    }

    return InkWell(
      key: ValueKey(category.id),
      onTap: () {
        if (category.id == 1) return; // 지정되지 않음 카테고리는 수정 불가
        ref
            .read(colorProvider.notifier)
            .update((state) => ColorUtils.stringToColor(category.color));
        showModalBottomSheet(
            context: context,
            builder: (context) {
              return CategoryInputModalScreen(
                category: category,
                isEdit: true,
              );
            });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).cardColor,
        ),
        child: Center(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric
                (horizontal: 4),
                child: Icon(Icons.more_horiz,
                    color: ColorUtils.stringToColor(category.color)),
              ),
              Text(
                category.name,
                style: textTheme,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
