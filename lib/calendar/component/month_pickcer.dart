//* Reference : https://stackoverflow.com/questions/63724025/flutter-create-dropdown-month-year-selector

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthPicker extends StatefulWidget {
  @override
  _MonthPickerState createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker>
    with SingleTickerProviderStateMixin {
  bool pickerIsExpanded = false;
  int _pickerYear = DateTime.now().year;
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  dynamic _pickerOpen = false;

  void switchPicker() {
    setState(() {
      _pickerOpen ^= true;
    });
  }

  List<Widget> generateRowOfMonths(from, to) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(_pickerYear, i, 1);
      //# 선택된 달과 같으면 보라색으로 표시
      final backgroundColor = dateTime.isAtSameMomentAs(_selectedMonth)
          ? Colors.purple
          : Colors.transparent;
      months.add(
        AnimatedSwitcher(
          duration: kThemeChangeDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: TextButton(
            key: ValueKey(backgroundColor),
            onPressed: () {
              setState(() {
                _selectedMonth = dateTime;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: CircleBorder(),
            ),
            child: Text(
              DateFormat('MMM').format(dateTime),
            ),
          ),
        ),
      );
    }
    return months;
  }

  Widget generateMonths() {
    return SizedBox(
      height: _pickerOpen ? null : 0.0,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: generateRowOfMonths(1, 6),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: generateRowOfMonths(7, 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          //# Header
          Row(
            children: [
              //* 왼쪽 클릭시 이전 년도로 이동
              IconButton(
                onPressed: () {
                  setState(() {
                    _pickerYear = _pickerYear - 1;
                  });
                },
                icon: Icon(Icons.navigate_before_rounded),
              ),
              //# 선택된 년도
              Expanded(
                child: GestureDetector(
                  onTap: switchPicker,
                  child: Center(
                    child: Text(
                      _pickerYear.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _pickerYear = _pickerYear + 1;
                  });
                },
                icon: Icon(Icons.navigate_next_rounded),
              ),
            ],
          ),
          AnimatedSize(
              curve: Curves.easeInOut,
              vsync: this,
              duration: Duration(milliseconds: 300),
              child: generateMonths()),
          SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
