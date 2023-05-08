import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';

class TextTypeTextFormField extends StatelessWidget {
  String? hintText;
  FormFieldValidator<String?>? validator;
  FormFieldSetter<String>? onSaved;
  final GestureTapCallback onTap;

  TextTypeTextFormField(
      {required this.onTap,
      this.validator,
      this.onSaved,
      this.hintText,
      super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: Theme.of(context).textTheme.bodyMedium,
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
        decoration:
            InputDecoration(border: InputBorder.none, 
            hintStyle: Theme.of(context).textTheme.bodyMedium,
            hintText: hintText));
  }
}

class NumberTypeTextFormField extends ConsumerStatefulWidget {
  String? hintText;
  FormFieldValidator<String?>? validator;
  FormFieldSetter<String>? onSaved;
  final GestureTapCallback onTap;
  NumberTypeTextFormField(
      {required this.onTap,
      this.validator,
      this.onSaved,
      this.hintText,
      super.key});

  @override
  ConsumerState<NumberTypeTextFormField> createState() =>
      _NumberTypeTextFormFieldState();
}

class _NumberTypeTextFormFieldState
    extends ConsumerState<NumberTypeTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        style: Theme.of(context).textTheme.bodyMedium,
        //: 키보드가 숫자만 표시됨
        keyboardType: TextInputType.number,
        //: 숫자만 입력되게 함
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly,
          // 세자리마다 콤마
          CurrencyInputFormatter()
        ],
        textAlign: TextAlign.right,
        //# 키보드 올라오면 키보드 크기 만큼 위로 올라가게 구현
        onTap: widget.onTap,
        //: 입력한 값 저장
        onSaved: widget.onSaved,
        validator: widget.validator,
        decoration: InputDecoration(
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          hintText: widget.hintText != null
              ? CustomNumberUtils.formatNumber(double.parse(widget.hintText!))
              : null,
          border: InputBorder.none,
        ));
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text.replaceAll(',', '');
    final int value = int.tryParse(newText) ?? 0;

    if (value == 0) {
      return newValue.copyWith(text: '');
    }

    final formattedText = _formatNumber(newText);

    return newValue.copyWith(
        text: formattedText,
        selection: TextSelection.collapsed(offset: formattedText.length));
  }

  String _formatNumber(String text) {
    final buffer = StringBuffer();
    int count = 0;

    for (int i = text.length - 1; i >= 0; i--) {
      count++;
      buffer.write(text[i]);
      if (count == 3 && i != 0) {
        buffer.write(',');
        count = 0;
      }
    }

    return buffer.toString().split('').reversed.join('');
  }
}
