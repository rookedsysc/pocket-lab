import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class TextTypeTextFormField extends StatelessWidget {
  String? hintText;
  FormFieldValidator<String?>? validator;
  FormFieldSetter<String>? onSaved;
  final GestureTapCallback onTap;
  
  TextTypeTextFormField ({required this.onTap,this.validator,this.onSaved,this.hintText,super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
          keyboardType: TextInputType.text,
          textAlign: TextAlign.right,
          //# 키보드 올라오면 키보드 크기 만큼 위로 올라가게 구현
          validator: validator,
          //: 입력한 값 저장
          onSaved: onSaved,
          //: 유저가 다시 선택하거나 텍스트를 변경할 때 유효성 검사 기능이 트리거 됨
          autovalidateMode: AutovalidateMode.onUserInteraction,
          autofocus: true,
          onTap: onTap,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText));
  }
}

class NumberTypeTextFormField extends StatelessWidget {
  String? hintText;
  FormFieldValidator<String?>? validator;
  FormFieldSetter<String>? onSaved;
  final GestureTapCallback onTap;
  NumberTypeTextFormField ({required this.onTap,this.validator,this.onSaved,this.hintText,super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
          //: 키보드가 숫자만 표시됨
          keyboardType: TextInputType.number,
          //: 숫자만 입력되게 함
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          textAlign: TextAlign.right,
          //# 키보드 올라오면 키보드 크기 만큼 위로 올라가게 구현
          onTap: onTap,
          //: 입력한 값 저장
          onSaved: onSaved,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
          ));
  }
}