import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/component/input_tile.dart';

class InputModalScreen extends ConsumerStatefulWidget {
  ///: 외부에서 입력 옵션 받아와서 사이즈는 여기서 정함
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

  //: 삭제 버튼
  bool? isDelButton;

  //: 삭제 버튼을 눌렀을 경우
  VoidCallback? onDelPressed;

  String? title;

  InputModalScreen(
      {required this.scrollController,
      required this.isEdit,
      required this.formKey,
      required this.inputTile,
      required this.onSavePressed,
      this.isDelButton,
      this.onDelPressed,
      this.title,
      super.key});

  @override
  ConsumerState<InputModalScreen> createState() => _InputModalScreenState();
}

class _InputModalScreenState extends ConsumerState<InputModalScreen> {
  double _bottomInsets = 0; 

  @override
  Widget build(BuildContext context) {
    _bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    // debugPrint(_bottomInsets.toString());
    return Scaffold(
      body: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: CupertinoScaffold(
          transitionBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: ListView(
            controller: widget.scrollController,
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
        mainAxisAlignment: widget.isDelButton == true
            ? MainAxisAlignment.end
            : MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.blue,
              )),
          if (!_isTitleNull())
            Text(
              widget.title!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

          if (_isDelButtonExist() && _isTitleNull())
            Expanded(child: SizedBox()),
          TextButton(
            onPressed: widget.onSavePressed,
            child: Text(
              widget.isEdit ? 'EDIT'.tr() : 'ADD'.tr(),
              // style: widget.textStyle
              //     ?.copyWith(color: Theme.of(context).iconTheme.color),
            ),
          ),
          //: 삭제 버튼
          if (widget.isDelButton == true)
            TextButton(
              onPressed: widget.onDelPressed,
              child: Text(
                "DEL".tr(),
                style: TextStyle(color: Colors.red),
              ),
            )
        ],
      ),
    );
  }

  bool _isTitleNull() {
    return widget.title == null;
  }

  bool _isDelButtonExist() {
    return widget.isDelButton == true;
  }
}
