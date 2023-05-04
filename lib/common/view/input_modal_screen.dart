import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/component/input_tile.dart';

class InputModalScreen extends ConsumerStatefulWidget {
  ///: 외부에서 입력 옵션 받아와서 사이즈는 여기서 정
  final List<InputTile> inputTile;

  ///: textField 등에 적용할 formkey
  final GlobalKey<FormState> formKey;

  ///: 저장 / ADD 버튼 눌렀을 경우 실행할 함수
  final VoidCallback onSavePressed;

  ///: 저장 버튼인지 ADD 버튼인지 구분
  ///: false면 Edit 버튼
  final bool isEdit;

  ///: 스크롤 컨트롤러
  final ScrollController scrollController;

  const InputModalScreen(
      {required this.scrollController,
      required this.isEdit,
      required this.formKey,
      required this.inputTile,
      required this.onSavePressed,
      super.key});

  @override
  ConsumerState<InputModalScreen> createState() => _InputModalScreenState();
}

class _InputModalScreenState extends ConsumerState<InputModalScreen> {
  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Column(
          children: [
            ///# 상단 버튼 (cancel, add)
            _topButton(context),
            SizedBox(
              height: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                key: widget.formKey,
                child: Column(
                  ///# 입력 옵션
                  children: <Widget>[
                    ...List.generate(widget.inputTile.length,
                        (index) => widget.inputTile[index])
                  ],
                ),
              ),
            ),

            ///# 키보드 올라왔을 때, 키보드 높이만큼 여백
            SizedBox(
              height: bottomInsets,
            ),
          ],
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
