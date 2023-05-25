import 'package:flutter/material.dart';

class TwoRowLayout extends StatelessWidget {
  final Widget firstWidget;
  final Widget secondWidget;
  const TwoRowLayout(
      {required this.firstWidget, required this.secondWidget, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      firstWidget,
      secondWidget
    ],
  );
  }
}