import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/component/custom_text_form_field.dart';
import 'package:pocket_lab/common/component/input_tile.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/common/view/input_modal_screen.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/provider/goal_list_provider.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:pocket_lab/goal/view/goal_screen.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class GoalConfigScreen extends ConsumerWidget {
  String goalName = "";
  double amount = 0;
  Goal? goal;
  GoalConfigScreen({this.goal, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InputModalScreen(
        scrollController: ref.watch(goalScrollControllerProvider),
        isEdit: false,
        formKey: _formKey,
        onSavePressed: _onSavePressed(context: context, ref: ref),
        inputTile: _inputTileList(ref));
  }

  List<InputTile> _inputTileList(WidgetRef ref) {
    return [
      //# goal 이름 입력
      InputTile(
          fieldName: "Goal Name",
          inputField: TextTypeTextFormField(
            hintText: goal != null ? goal!.name : null,
            onTap: _onTap(ref),
            onSaved: _goalInputTileOnSaved,
            //: 외부에서 받아온 goal이 존재할 경우 validator를 null로 설정
            validator: goal != null ? null : _goalInputTileValidator,
          )),
      //# 목표액 입력
      InputTile(
        fieldName: "Amount",
        inputField: NumberTypeTextFormField(
          hintText: goal != null ? goal!.amount.toString() : null,
          onTap: _onTap(ref),
          onSaved: _amountInputTileOnSaved,
          //: 외부에서 받아온 goal이 존재할 경우 validator를 null로 설정
          validator: goal != null ? null : _amountInputTileValidator,
        ),
      ),
    ];
  }

  void _goalInputTileOnSaved(newValue) {
    //: newValue가 null인 경우 save 하지 않음
    if (newValue == null || newValue == "") return;
    goal?.name = newValue;
    goalName = newValue!;
  }

  void _amountInputTileOnSaved(newValue) {
    //: newValue가 null인 경우 save 하지 않음
    if (newValue == null || newValue == "") return;
    debugPrint(newValue);

    /// newValue가 ₩50,000와 같은 형태로 들어오기 때문에
    /// 숫자만 추출하여 double로 변환
    String _amountOnlyDigit = CustomNumberUtils.getNumberFromString(newValue);
    goal?.amount = double.parse(_amountOnlyDigit);
    amount = double.parse(_amountOnlyDigit);
  }

  String? _goalInputTileValidator(String? val) {
    // null인지 check
    if (val == null || val.isEmpty) {
      return ('Input Value');
    }

    return null;
  }

  String? _amountInputTileValidator(String? val) {
    // null인지 check
    if (val == null || val.isEmpty) {
      return ('Input Value');
    }

    return null;
  }

  GestureTapCallback _onTap(WidgetRef ref) {
    return () {
      final scrollController = ref.watch(goalScrollControllerProvider);
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    };
  }

  VoidCallback _onSavePressed(
      {required BuildContext context, required WidgetRef ref}) {
    return () async {
      //: 오류가 없다면 실행하는 부분
      //: 여기서 오류가 없다는 것은 값이 모두 들어 갔다는 것임.
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        //# edit인 경우 goal이 애초에 있으며
        //# name과 amount만 변경해줌
        if (goal != null) {
          await ref
              .read(goalRepositoryProvider.future)
              .then((value) => value.addGoal(goal!));
          ref.refresh(goalLocalListProvider.notifier).addGoal(goal!);
          Navigator.of(context).pop();
          return;
        }
        //# goal이 null인 경우 애초에 값이 없는 경우 이므로
        //# 새로운 Goal Instance를 생성해줌
        else {
          goal = Goal(
            name: goalName,
            amount: amount,
          );
        }

        //: goal이 null이 될 경우는 없겠지만 혹시나 해서 넣어둠
        if (goal == null) {
          return;
        }
        await ref
            .read(goalRepositoryProvider.future)
            .then((value) => value.addGoal(goal!));
        ref.read(goalLocalListProvider.notifier).addGoal(goal!);
        Navigator.of(context).pop();
      }
    };
  }
}
