import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/custom_slidable.dart';
import 'package:pocket_lab/common/component/header_collection.dart';
import 'package:pocket_lab/common/util/color_utils.dart';
import 'package:pocket_lab/home/view/home_screen/category_input_modal_screen.dart';
import 'package:pocket_lab/home/view/widget/color_picker_alert_dialog.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:sheet/route.dart';

class CategoryList extends ConsumerWidget {
  bool isEdit = false;
  List<TransactionCategory> _categories = [];
  CategoryList({super.key});

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderCollection(headerType: HeaderType.categoryList),
                  ElevatedButton.icon(
                    onPressed: () {
                      isEdit = true;
                    },
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    label: Text("Edit"),
                  )
                ],
              ),
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
        Navigator.of(context).push(
          CupertinoSheetRoute(
            initialStop: 0.3,
            stops: <double>[0, 0.3, 1],
            // Screen은 이동할 스크린
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            builder: (context) => CategoryInputModalScreen(
              isEdit: false,
            ),
          ),
        );
      },
      child: Container(
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
        ref
            .read(colorProvider.notifier)
            .update((state) => ColorUtils.stringToColor(category.color));
        Navigator.of(context).push(
          CupertinoSheetRoute(
            initialStop: 0.3,
            stops: <double>[0, 0.3, 1],
            // Screen은 이동할 스크린
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            builder: (context) => CategoryInputModalScreen(
              category: category,
              isEdit: true,
            ),
          ),
        );
      },
      child: Container(
        color: ColorUtils.stringToColor(category.color),
        child: Center(
          child: Text(
            category.name,
            style: textTheme.copyWith(color: _textColor),
          ),
        ),
      ),
    );
  }
}
