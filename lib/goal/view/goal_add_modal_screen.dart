import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sheet/sheet.dart';

class GoalAddModalScreen extends StatefulWidget {
  final Color cardColor;
  //: body text1
  final TextStyle? textStyle;
  //: 전체 화면의 1/2 사이즈
  final double height;
  //: 전체 화면의 가로 사이즈
  final double width;
  GoalAddModalScreen(
      {required this.width,
      required this.height,
      required this.textStyle,
      required this.cardColor,
      super.key});

  @override
  State<GoalAddModalScreen> createState() => _GoalAddModalScreenState();
}

class _GoalAddModalScreenState extends State<GoalAddModalScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return Material(
      child: SingleChildScrollView(
        controller: scrollController,
        child: SizedBox(
          //# 키보드가 올라오면 bottomInsets + 안에 있는 위젯들의 높이 만큼 더해주고
          //# 그렇지 않으면 그냥 widget.height(만큼 높이를 설정
          //TODO: 하위 위젯들 높이 바뀌면 해당 부분 수정 필요
          height: bottomInsets != 0 ? 150 + bottomInsets : widget.height,

          child: Column(
            children: [
              //# 상단 버튼 (cancel, add)
              _bottomButton(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        _field(
                            fieldName: 'Goal Name', bottomInsets: bottomInsets, isAmount: true),
                        _field(fieldName: 'Amount', bottomInsets: bottomInsets, isAmount: false),
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

  SizedBox _bottomButton(BuildContext context) {
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                Navigator.pop(context);
              }
            },
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

  Widget _field({required String fieldName, required double bottomInsets, required isAmount}) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: widget.width * 0.25,
            child: Text(
              fieldName,
              style: widget.textStyle,
            ),
          ),
          SizedBox(
            width: widget.width * 0.5,
            child: TextFormField(
              //: amount section에 입력하면 숫자만 입력되게 함
              keyboardType: isAmount ? TextInputType.number : TextInputType.text,
              textAlign: TextAlign.end,
                //# 키보드 올라오면 키보드 크기 만큼 위로 올라가게 구현
                onTap: () {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }, validator: (String? val) {
              // null인지 check
              if (val == null || val.isEmpty) {
                return ('Input Value');
              }

              return null;
            }),
          ),
        ],
      ),
    );
  }
}
