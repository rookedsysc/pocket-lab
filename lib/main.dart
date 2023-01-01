import 'package:flutter/material.dart';
import 'package:pocket_lab/common/view/root_tab.dart';
import 'package:pocket_lab/home/view/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RootTab(),
    );
  }
}

