import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          color: Colors.blue,
        ),
        Container(
          height: 200,
          color: Colors.red,
        ),
        Container(
          height: 200,
          color: Colors.orange,
        ),
        Container(
          height: 200,
          color: Colors.green,
        ),
      ],
    );
  }
}