import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/input_tile.dart';
import 'package:pocket_lab/goal/component/goal_list_view.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:sheet/route.dart';

final goalScrollControllerProvider = Provider<ScrollController>((ref) {
  final ScrollController _scrollController = ScrollController();
  return _scrollController;
});

class GoalScreen extends ConsumerWidget {
  // formkey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String goalName = "";
  int amount = 0;
  Goal goal = Goal(name: "", amount: 0);
  GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Goal> goals = [];
    final scrollController = ref.watch(goalScrollControllerProvider);
    return Scaffold(
      appBar: _appBar(context, ref),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: goals == null || goals.isEmpty
            ? Text("설정된 목표가 없습니다.")
            : ListView.builder(
                itemBuilder: (context, index) => Container(
                  ///: container 둥글게
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: ListTile(
                    title: Text(goals[index].name),
                    subtitle: Text(goals[index].firstDate.toString()),
                    trailing: Text(goals[index].amount.toString()),
                  ),
                ),
                itemCount: goals.length,
              ),
      )),
    );
  }

  AppBar _appBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      iconTheme: Theme.of(context).iconTheme,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ///: 그림자 제거
      elevation: 0,

      title: Text(
        "목표 설정",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: [
        ///# 추가 버튼
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            showMaterialModalBottomSheet(
              expand: false,
              context: context,
              builder: ((context) {
                return InputModalScreen(
                    scrollController: ref.watch(goalScrollControllerProvider),
                    isSave: false,
                    formKey: _formKey,
                    onSavePressed: _onSavePressed(context: context, ref: ref),
                    inputTile: _inputTileList(ref));
              }),
            );
          },
        ),
      ],
    );
  }

  VoidCallback _onSavePressed(
      {required BuildContext context, required WidgetRef ref}) {
    return () async {
      //: 오류가 없다면 실행하는 부분
      //: 여기서 오류가 없다는 것은 값이 모두 들어 갔다는 것임.
      if (_formKey.currentState!.validate()) {
        goal = Goal(
          name: goalName,
          amount: amount,
        );
        _formKey.currentState!.save();
        await ref
            .read(goalProvider.future)
            .then((value) => value.addGoal(goal));
        Navigator.of(context).pop();
      }
    };
  }

  List<InputTile> _inputTileList(WidgetRef ref) {
    final scrollController = ref.watch(goalScrollControllerProvider);
    return [
      //# goal 이름 입력
      InputTile(
        fieldName: "Goal Name",
        inputField: TextFormField(
          //: amount section에 입력하면 숫자만 입력되게 함
          keyboardType: TextInputType.text,
          textAlign: TextAlign.end,
          //# 키보드 올라오면 키보드 크기 만큼 위로 올라가게 구현
          onTap: () {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          validator: (String? val) {
            // null인지 check
            if (val == null || val.isEmpty) {
              return ('Input Value');
            }

            return null;
          },
          //: 입력한 값 저장
          onSaved: ((newValue) {
            goalName = newValue!;
          }),
        ),
      ),
      //# 가격 입력
      InputTile(
        fieldName: "Amount",
        inputField: TextFormField(
          //: amount section에 입력하면 숫자만 입력되게 함
          keyboardType: TextInputType.number,
          textAlign: TextAlign.end,
          //# 키보드 올라오면 키보드 크기 만큼 위로 올라가게 구현
          onTap: () {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          },
          validator: (String? val) {
            // null인지 check
            if (val == null || val.isEmpty) {
              return ('Input Value');
            }

            return null;
          },
          //: 입력한 값 저장
          onSaved: ((newValue) {
            amount = int.parse(newValue!);
          }),
        ),
      )
    ];
  }
}

///! 동작안함
///! 왜 그런지 모르겠음
// class GoalScreen extends ConsumerWidget {
//   const GoalScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: Theme.of(context).iconTheme,
//         backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         ///: 그림자 제거
//         elevation: 0,

//         title: Text(
//           "목표 설정",
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),
//         actions: [
//           ///# 추가 버튼
//           IconButton(
//             icon: Icon(Icons.add),
//             onPressed: () {
//               showMaterialModalBottomSheet(
//                 expand: false,
//                 context: context,
//                 builder: ((context) {
//                   return GoalAddModalScreen(
//                     height: MediaQuery.of(context).size.height * 0.49,
//                     width: MediaQuery.of(context).size.width,
//                     textStyle: Theme.of(context).textTheme.bodyMedium,
//                     cardColor: Theme.of(context).cardColor,
//                   );
//                 }),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
//           child: GoalListView(),
//         ),
//       ),
//     );
//   }
// }
