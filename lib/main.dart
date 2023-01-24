
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/common/view/root_tab.dart';
import 'package:pocket_lab/goal/view/goal_screen.dart';
import 'package:pocket_lab/home/view/budget_screen.dart';
import 'package:pocket_lab/home/view/drawer_screen.dart';
import 'package:pocket_lab/home/view/home_screen.dart';
import 'package:pocket_lab/home/view/transaction_screen.dart';
import 'package:sheet/route.dart';

import 'goal/view/goal_add_modal_screen.dart';

void main() async {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _theme,
      darkTheme: _darkTheme,
      themeMode: ThemeMode.system,

      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute,
    );
  }

  MaterialPageRoute? _onGenerateRoute(settings) {
    switch (settings.name) {
      case('/'):
        return MaterialExtendedPageRoute(builder: ((_) => RootTab()));
      case('/drawer_screen') :
        return MaterialExtendedPageRoute(builder: ((_) => DrawerScreen()));
      case('/drawer_screen/goal_screen') :
        return MaterialExtendedPageRoute(builder: (((_) => GoalScreen())));
      case('/drawer_screen/budget_screen') :
        return MaterialExtendedPageRoute(builder: (((_) => BudgetScreen())));
    }
    return null;
  }

  final ThemeData _theme = ThemeData(
    scaffoldBackgroundColor: const Color.fromRGBO(236, 237, 240, 1),
    //* Bottom Navigation Bar 색
    canvasColor: const Color.fromRGBO(236, 237, 240, 1),

    iconTheme: const IconThemeData(color: Colors.blue),

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

    iconTheme: const IconThemeData(color: Colors.blue),

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
  final GoRouter _router = GoRouter(
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

