import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocket_lab/calendar/component/month_header.dart';
import 'package:pocket_lab/calendar/component/week_header.dart';
import 'package:pocket_lab/calendar/utils/calendar_utils.dart';
import 'package:pocket_lab/calendar/view/calendar_screen.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends ConsumerStatefulWidget {
  const Calendar({super.key});

  @override
  ConsumerState<Calendar> createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late CalendarModel _calendarState;


  void initRiverpod() {
    _calendarState = ref.watch(calendarProvider);
    _focusedDay = _calendarState.focusedDay;
    if (_calendarState.selectedDay != null) {
      _selectedDay = _calendarState.selectedDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    initRiverpod();

    return SizedBox(
      //* 월의 주 수에 따라서 Calendar 크기 조정
      height: CalendarUtils().getCalendarHeight(_focusedDay),
      child: TableCalendar(
          //: 가능한 모든 높이 차지함
          shouldFillViewport: true,
          //: header 없앰
          headerVisible: false,

          focusedDay: _focusedDay,
          firstDay: DateTime.now().subtract(Duration(days: 365 * 10)),
          lastDay: DateTime.now().add(Duration(days: 365 * 10)),
          selectedDayPredicate: (DateTime dateTime) {
            if (_selectedDay == null) {
              return false;
            }

            return dateTime.year == _selectedDay!.year &&
                dateTime.month == _selectedDay!.month &&
                dateTime.day == _selectedDay!.day;
          },
          onDaySelected: _onDaySelected(),
          onPageChanged: _onPageChanged(),
          calendarBuilders: _calendarBuilders()),
    );
  }

  OnDaySelected _onDaySelected() {
    return (selectedDay, focusedDay) {
      setState(() {
        ref.read(calendarProvider.notifier).setSelectedDay(selectedDay);
        ref.read(calendarProvider.notifier).setFocusedDay(selectedDay);
      });
    };
  }

  void Function(DateTime focusedDay) _onPageChanged() {
    return (focusedDay) {
      debugPrint("[*] onPageChaged : ${focusedDay.toString()}");
      setState(() {
        ref.read(calendarProvider.notifier).setFocusedDay(focusedDay);
      });
    };
  }

  CalendarBuilders _calendarBuilders(
      {Map<DateTime, int>? totalIncome, Map<DateTime, int>? totalExpenditure}) {
    const TextStyle _weekendTextStyle =
        TextStyle(color: Colors.red, fontSize: 12);
    return CalendarBuilders(
      selectedBuilder: (context, date, focusedDay) {
        return _calendarBox(
            //totalExpenditure: totalExpenditure?[dateFormate_yyDDmm(date)],
            //totalIncome: totalIncome?[dateFormate_yyDDmm(date)],
            context: context,
            // 다크 모드에선 흰색 글씨 라이트 모드에선 검은색 글씨
            date: date);
      },
      todayBuilder: (context, date, focusedDay) {
        return _calendarBox(
            //totalExpenditure: totalExpenditure?[dateFormate_yyDDmm(date)],
            //totalIncome: totalIncome?[dateFormate_yyDDmm(date)],
            context: context,
            textColor: Colors.blue,
            date: date);
      },
      defaultBuilder: (context, date, focusedDay) {
        return _calendarBox(
            //totalExpenditure: totalExpenditure?[dateFormate_yyDDmm(date)],
            //totalIncome: totalIncome?[dateFormate_yyDDmm(date)],
            context: context,
            date: date);
      },
      outsideBuilder: (context, date, focusedDay) {
        return _calendarBox(
            //totalExpenditure: totalExpenditure?[dateFormate_yyDDmm(date)],
            //totalIncome: totalIncome?[dateFormate_yyDDmm(date)],
            context: context,
            textColor: Colors.grey,
            date: date);
      },
      dowBuilder: (context, date) {
        final text = DateFormat.E('en_US').format(date);
        if (text == 'Sun' || text == 'Sat') {
          return Text(
            text,
            style: _weekendTextStyle,
            textAlign: TextAlign.center,
          );
        }

        return Text(
          text,
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        );
      },
    );
  }

  Widget _calendarBox({
    required BuildContext context,
    required DateTime date,
    Color? textColor,
    int? totalIncome,
    int? totalExpenditure,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width / 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            date.day.toString(),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w700,
              color: textColor ?? Theme.of(context).textTheme.bodyMedium!.color,
            ),
            textAlign: TextAlign.center,
          ),
          //: 오늘 수입/지출
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (totalIncome != null)
                  Text(
                    totalIncome.toString(),
                    style: TextStyle(fontSize: 10, color: Colors.green),
                  ),
                if (totalExpenditure != null)
                  Text(
                    totalExpenditure.toString(),
                    style: TextStyle(fontSize: 10, color: Colors.red),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

