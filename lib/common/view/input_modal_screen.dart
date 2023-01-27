import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/goal/model/goal_model.dart';
import 'package:pocket_lab/goal/repository.dart/goal_repository.dart';
import 'package:sheet/sheet.dart';

class InputModalScreen extends ConsumerStatefulWidget {
    ///: 외부에서 입력 옵션 받아와서 사이즈는 여기서 정
  final List<InputTile> inputTile;
  ///: textField 등에 적용할 formkey
  final GlobalKey<FormState> formKey;
  ///: 저장 / ADD 버튼 눌렀을 경우 실행할 함수
  final VoidCallback onSavePressed;
  ///: 저장 버튼인지 ADD 버튼인지 구분
  final bool isSave;

  const InputModalScreen(
      {required this.isSave,
      required this.formKey,
      required this.inputTile,
      required this.onSavePressed,
      super.key});

  @override
  ConsumerState<InputModalScreen> createState() => _GoalAddModalScreenState();
}

final inputModalScrollProvider = Provider<ScrollController>((ref) {
  final ScrollController scrollController = ScrollController();
  return scrollController;
});

class _GoalAddModalScreenState extends ConsumerState<InputModalScreen> {

  @override
  void dispose() {
    ref.read(inputModalScrollProvider).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController = ref.watch(inputModalScrollProvider);
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return Material(
      child: SingleChildScrollView(
        controller: scrollController,
        child: SizedBox(
          ///# 키보드가 올라오면 bottomInsets + 안에 있는 위젯들의 높이 만큼 더해주고
          ///# 그렇지 않으면 그냥 widget.height(만큼 높이를 설정
          //TODO: 하위 위젯들 높이 바뀌면 해당 부분 수정 필요
          height: bottomInsets != 0 ? 168 + bottomInsets : MediaQuery.of(context).size.height * 0.49,

          child: Column(
            children: [
              ///# 상단 버튼 (cancel, add)
              _topButton(context),
              SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  child: Form(
                    key: widget.formKey,
                    child: Column(
                      ///# 입력 옵션
                      children: <Widget>[
                        ...List.generate(
                            widget.inputTile.length,
                            (index) => _field(
                              width: MediaQuery.of(context).size.width,
                                fieldName: widget.inputTile[index].fieldName,
                                inputField: widget.inputTile[index].inputField))
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _topButton(BuildContext context) {
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
          TextButton(
            onPressed: widget.onSavePressed,
            child: Text(
              'Add',
              // style: widget.textStyle
              //     ?.copyWith(color: Theme.of(context).iconTheme.color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({required double width,required String fieldName, required Widget inputField}) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Text(
              fieldName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SizedBox(width: width * 0.5, child: inputField),
        ],
      ),
    );
  }
}

class InputTile {
  final String fieldName;
  final Widget inputField;

  InputTile({required this.fieldName, required this.inputField});
}
