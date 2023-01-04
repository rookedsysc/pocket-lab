import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pocket_lab/common/view/root_tab.dart';
import 'package:pocket_lab/home/view/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }

  //: GoRouter Route
  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
      path: '/',
      name: RootTab.routeName,
      builder: (_, state) => RootTab(),
    ),
    ],
  );
}

