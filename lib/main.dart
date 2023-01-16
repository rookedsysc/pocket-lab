import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pocket_lab/common/view/root_tab.dart';
import 'package:pocket_lab/goal/view/goal_screen.dart';
import 'package:pocket_lab/home/view/budget_screen.dart';
import 'package:pocket_lab/home/view/home_screen.dart';
import 'package:pocket_lab/home/view/transaction_screen.dart';

void main() async {
  runApp(ProviderScope(child: MyApp()));
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

  //# GoRouter Route
  final _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: RootTab.routeName,
        builder: (_, state) => RootTab(),
        routes: [
          GoRoute(
            path: 'goal_detail_screen',
            name: GoalScreen.routeName,
            builder: (_, state) => GoalScreen(),
          ),
          // budget screen
          GoRoute(
            path: 'budget_screen',
            name: BudgetScreen.routeName,
            builder: (_, state) => BudgetScreen(),
          ),
        ],
      ),
    ],
  );
}

