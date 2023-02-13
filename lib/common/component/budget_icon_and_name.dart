import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BudgetIconAndName extends StatelessWidget {
  ///# 예산 아이콘 image 주소
  final String imgAddr;

  ///# 예산 이름
  final String name;

  ///# Row MainAxisAlignment
  final MainAxisAlignment? mainAxisAlignment;

  ///# Row CrossAxisAlignment
  final CrossAxisAlignment? crossAxisAlignment;
  
  const BudgetIconAndName(
      {required this.imgAddr,
      required this.name,
      this.crossAxisAlignment,
      this.mainAxisAlignment,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        Image.asset(imgAddr, height: 22.5, width: 22.5),
        const SizedBox(width: 4.0),
        Text(
          name,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontSize: 20.0, fontWeight: FontWeight.w900),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }

  Widget copyWith({String? imgAddr, String? name, Key? key}) {
    return BudgetIconAndName(
      imgAddr: imgAddr ?? this.imgAddr,
      name: name ?? this.name,
      key: key ?? this.key,
    );
  }
}
