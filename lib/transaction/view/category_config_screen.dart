import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/transaction/model/category_model.dart';
import 'package:pocket_lab/transaction/repository/category_repository.dart';

class CategoryConfigScreen extends ConsumerStatefulWidget{
  final bool isEdit;

  const CategoryConfigScreen({required this.isEdit, super.key});

  @override
  ConsumerState<CategoryConfigScreen> createState() => _CategoryConfigScreenState();
}

class _CategoryConfigScreenState extends ConsumerState<CategoryConfigScreen> {
  List<TransactionCategory> categories = [];
  late StreamSubscription _categoryListener;

  didChangeDependencies() {
    super.didChangeDependencies();
    _categoryListener = ref
        .watch(categoryRepositoryProvider.notifier)
        .getAllCategories()
        .listen((event) {
          categories = event;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _categoryListener.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
    // Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //     elevation: 0,
    //     leading: IconButton(
    //       icon: Icon(
    //         Icons.arrow_back_ios,
    //         color: Theme.of(context).iconTheme.color,
    //       ),
    //       onPressed: () {
    //         Navigator.of(context).pop();
    //       },
    //     ),
    //     title: Text(
    //       "Select Category",
    //       style: Theme.of(context).textTheme.bodyLarge,
    //     ),
    //   ),
    //   body: 
      Material(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // Expanded(
              //   child: ListView.builder(
              //       itemBuilder: (context, index) {
              //         return Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Container(
              //             height: 50,
              //             decoration: BoxDecoration(
              //               color: Theme.of(context).cardColor,
              //               borderRadius: BorderRadius.circular(5),
              //             ),
              //             child: Row(
              //               children: [
              //                 Text(categories[index].name),
              //               ],
              //             ),
              //           ),
              //         );
              //       },
              //       itemCount: categories.length),

              // ),
              _topButton(context),

              Expanded(
                  child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2),
                children: List.generate(
                    categories.length,
                    (index) => Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Text(categories[index].name),
                            ],
                          ),
                        )),
              ))
            ],
          ),
        ),
    );
  }

  SizedBox _topButton(BuildContext context) {
    return SizedBox(
      height: 30.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          TextButton(
            onPressed: () {},
            child: Text(
              widget.isEdit ? 'EDIT' : 'ADD',
              // style: widget.textStyle
              //     ?.copyWith(color: Theme.of(context).iconTheme.color),
            ),
          ),
        ],
      ),
          );
  }
}
