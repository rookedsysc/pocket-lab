import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

const int NUMBER_OF_KEY = 40;

class _TestScreenState extends State<TestScreen> {
  final ScrollController _controller = ScrollController();

  final List<GlobalKey> _keys = List.generate(NUMBER_OF_KEY, (_) => GlobalKey());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Material(
        child: ListView(
          controller: _controller,
          children: [
            ...List.generate(NUMBER_OF_KEY, (index) {
              if (index % 2 == 0) {
                return _emptyContainer();
              }
              return _textFormField(index ~/ 2);
            }),
          ],
        ),
      ),
    );
  }

  Widget _emptyContainer() {
    return Container(
      height: 200,
    );
  }

  Widget _textFormField(int keyIndex) {
    return Container(
      key: _keys[keyIndex],
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        onTap: () => _scrollToCurrentField(keyIndex),
        decoration: InputDecoration(focusColor: Colors.blue),
      ),
    );
  }

  void _scrollToCurrentField(int keyIndex) {
    final keyContext = _keys[keyIndex].currentContext;

    if (keyContext != null) {
      // 위치를 얻습니다.
      final box = keyContext.findRenderObject() as RenderBox;
      _controller.animateTo(
        box.localToGlobal(Offset.zero).dy,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
}