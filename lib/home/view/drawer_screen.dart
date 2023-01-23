import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pocket_lab/home/view/menu_screen.dart';
import 'package:pocket_lab/home/view/home_screen.dart';
import 'package:sheet/route.dart';

class DrawerScreen extends StatefulWidget {
  static const routeName = 'root_screen';
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final ZoomDrawerController _zoomDrawerController = ZoomDrawerController();
  @override
  Widget build(BuildContext context) {
    final double _slideWidth = MediaQuery.of(context).size.width * 0.9;

    return Scaffold(
      body: ZoomDrawer(
        style: DrawerStyle.style3,
        controller: _zoomDrawerController,
        menuScreen: MenuScreen(),
        mainScreen: HomeScreen(zoomDrawerController: _zoomDrawerController),
        //# Drawer 열었을 때 main화면 크기
        //: 작을 수록 화면 커짐
        mainScreenScale: 0.0,
        borderRadius: 0.0,
        showShadow: false,
        //# 기울기 
        angle: 0.0,
        drawerShadowsBackgroundColor: Colors.grey,
        //# slide 사이즈
        slideWidth: _slideWidth,
      ),
    );
  }
}