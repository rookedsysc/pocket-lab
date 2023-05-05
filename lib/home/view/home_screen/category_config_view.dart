import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/common/view/loading_view.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class CategoryConfigView extends ConsumerWidget {
  List<TransactionCategory> _categories = [];
  CategoryConfigView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<TransactionCategory>>(
        stream: ref
            .watch(categoryRepositoryProvider.notifier)
            .allCategoriesStream(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(child: const CircularProgressIndicator(),);
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
                height: 500,
                child: ReorderableGridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                    childAspectRatio: 5,
                    onReorder: ((oldIndex, newIndex) => null),
                    children: List.generate(_categories.length + 1, (index) {
                      if (_categories.length == index) {
                        return _addItem(context);
                      }

                      return _categoryItem(
                          category: _categories[index],
                          textTheme: Theme.of(context).textTheme.bodyMedium!);
                    })),
              ),
            ],
          );
        });
  }

  Widget _addItem(BuildContext context) {
    return InkWell(
      onTap: () {
        CupertinoScaffold.showCupertinoModalBottomSheet(context: context, builder: (context) => );
      },
      child: Container(
        key: ValueKey('add'),
        child: Center(
            child: Icon(
          Icons.add,
          color: Theme.of(context).textTheme.bodyLarge!.color,
        )),
      ),
    );
  }

  Widget _categoryItem(
      {required TransactionCategory category, required TextStyle textTheme}) {
    Color _textColor = Colors.black;

    if (ColorUtils.isBlackShade(category.color)) {
      _textColor = Colors.white;
    }

    return Container(
      key: ValueKey(category.id),
      color: ColorUtils.stringToColor(category.color),
      child: Center(
        child: Text(
          category.name,
          style: textTheme.copyWith(color: _textColor),
        ),
      ),
    );
  }
}
