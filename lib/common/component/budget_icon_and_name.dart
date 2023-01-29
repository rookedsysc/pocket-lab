import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class BudgetIconAndName extends StatelessWidget {
  //# 예산 아이콘 image 주소 
  final String imgAddr;
  //# 예산 이름
  final String name;

  const BudgetIconAndName({required this.imgAddr, required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(imgAddr, height: 30, width: 30),
        const SizedBox(width: 4.0),
        Text(
          name,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontSize: 20.0,
              fontWeight: FontWeight.w900
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
