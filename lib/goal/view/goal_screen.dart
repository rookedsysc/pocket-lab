import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/custom_text_form_field.dart';
import 'package:pocket_lab/common/component/input_tile.dart';
import 'package:pocket_lab/goal/component/goal_list_view.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/provider/goal_list_provider.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:pocket_lab/goal/view/goal_config_screen.dart';
import 'package:sheet/route.dart';
import 'package:sheet/sheet.dart';

final goalScrollControllerProvider = Provider<ScrollController>((ref) {
  final ScrollController _scrollController = ScrollController();
  return _scrollController;
});

class GoalScreen extends ConsumerWidget {
  String goalName = "";
  int amount = 0;
  Goal goal = Goal(name: "", amount: 0);
  GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: Column(
          children: [
            _topButton(context, ref),
            Expanded(child: GoalListView()),
          ],
        ),
      ),
    );
  }

  Widget _topButton(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showMaterialModalBottomSheet(
                expand: false,
                context: context,
                builder: ((context) {
                  return GoalConfigScreen();
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}
