//* Reference : https://stackoverflow.com/questions/63724025/flutter-create-dropdown-month-year-selector
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocket_lab/calendar/model/calendar_model.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
import 'package:pocket_lab/calendar/view/calendar_screen.dart';

class MonthPicker extends ConsumerStatefulWidget {
  const MonthPicker({super.key});
  @override
 ConsumerState<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends ConsumerState<MonthPicker>
    with SingleTickerProviderStateMixin {
  bool pickerIsExpanded = false;
  int _pickerYear = DateTime.now().year;
  DateTime _selectedMonth = DateTime.now(); 
  late CalendarModel _calendarState;

  dynamic _pickerOpen = false;

  void switchPicker() {
    setState(() {
      _pickerOpen ^= true;
    });
  }

  List<Widget> generateRowOfMonths(from, to) {
    List<Widget> months = [];
    Color backgroundColor;
    for (int i = from; i <= to; i++) {
      //# 선택된 해의 1~12월까지 생성
      DateTime dateTime = DateTime(_pickerYear, i, 1);
      
      months.add(
        AnimatedSwitcher(
          duration: kThemeChangeDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          //# 달을 누르면 달이 선택되고, 선택된 달이 있으면 그 달의 색깔을 보라색으로 표시
          child: TextButton(
            onPressed: () {
              setState(() {
                ref.read(calendarProvider.notifier).setFocusedDay(dateTime);
                debugPrint("[*] Month Picker Select Month : ${ref.read(calendarProvider).focusedDay}");
              });
            },
            style: TextButton.styleFrom(
              shape: const CircleBorder(),
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

  void initRiverpod() {
    setState(() {});
    _calendarState = ref.watch(calendarProvider);
    _pickerYear = _calendarState.focusedDay.year;
    if (_calendarState.selectedDay != null) {
      _selectedMonth = DateTime(
        _calendarState.selectedDay!.year,
        _calendarState.selectedDay!.month,
        1,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    initRiverpod();
    
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Row(
            children: [
              //# 왼쪽 버튼 
              //: 이전 년도로 이동
              IconButton(
                onPressed: () {
                  setState(() {
                    ref.read(calendarProvider.notifier).setFocusedDay(DateTime(_pickerYear -1, _calendarState.focusedDay.month, 1));
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
                      DateFormat('yyyy. MM.').format(_calendarState.focusedDay),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                  ),
                ),
              ),
              //# 오른쪽 버튼
              //: 다음 년도로 이동
              IconButton(
                onPressed: () {
                  setState(() {
                    ref.read(calendarProvider.notifier).setFocusedDay(DateTime(_pickerYear + 1, _calendarState.focusedDay.month, 1));
                  });
                },
                icon: const Icon(Icons.navigate_next_rounded),
              ),
            ],
          ),
          AnimatedSize(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: 300),
              child: generateMonths()),
          const SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}
