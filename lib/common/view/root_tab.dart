import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pocket_lab/calendar/view/calendar_screen.dart';
import 'package:pocket_lab/home/view/home_screen.dart';

class RootTab extends StatefulWidget {
  static const routeName = 'rootTab';
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int index = 0;

  @override
  void initState() {
    super.initState();

    //* length: 2 -> 2개의 탭.
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(tabListner);
  }

  void tabListner() {
    setState(() {
      //: 컨트롤러의 인덱스를 현재 인덱스에 넣어주겠다.
      index = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(tabListner);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(),
      body: _tabBarView(),
    );
  }

  Widget _bottomNavigationBar() => BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        items: const <BottomNavigationBarItem>[
          //* tab 추가시 수정
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Calendar',
          ),
        ],

        //: 탭을 눌렀을 때
        onTap: (int index) {
          debugPrint(index.toString());
          //: TabBarView의 해당하는 인덱스로 움직여라
          _tabController.animateTo(index);
        },
        currentIndex: index,
        selectedItemColor: Colors.amber[800],
      );

  Widget _tabBarView() {
    return TabBarView(
      children: [
        //* tab 추가시 수정
        HomeScreen(), CalendarScreen()
      ],
      physics: const NeverScrollableScrollPhysics(),
      controller: _tabController,
    );
  }
}
