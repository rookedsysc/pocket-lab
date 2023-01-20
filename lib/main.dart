import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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
      theme: _theme,
      darkTheme: _darkTheme,
      routerConfig: _router,
      themeMode: ThemeMode.system,
    );
  }

  final ThemeData _theme = ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(236, 237, 240, 1),
    //* Bottom Navigation Bar 색
    canvasColor: const Color.fromRGBO(236, 237, 240, 1),

    iconTheme: const IconThemeData(color: Colors.black),

    //# 메인 색상
    primaryColor: const Color.fromRGBO(74, 110, 94, 1),
    primaryColorLight: const Color.fromRGBO(74, 110, 94, 0.75),

    //# 텍스트 색상
    textTheme: const TextTheme(
      //: 보통 글귀
      bodyText1: TextStyle(color: Colors.black),
    ),

    cardColor: Colors.white
  );

  final ThemeData _darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(30, 30, 30, 1),
    //* Bottom Navigation Bar 색
    canvasColor: const Color.fromRGBO(30, 30, 30, 1),

    iconTheme: const IconThemeData(color: Colors.white),

    //# 메인 색상
    primaryColor: const Color.fromRGBO(74, 110, 94, 1),
    primaryColorLight: const Color.fromRGBO(74, 110, 94, 0.75),

    //# 텍스트 색상
    textTheme: const TextTheme(
      //: 보통 글귀
      bodyText1: TextStyle(color: Colors.white, ),
    ),

    cardColor: Colors.black,
  );

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

