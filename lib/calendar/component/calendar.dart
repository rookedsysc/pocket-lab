import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:pocket_lab/calendar/component/month_header.dart';
import 'package:pocket_lab/calendar/component/week_header.dart';
import 'package:pocket_lab/calendar/utils/calendar_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  DateTime focusedDay;
  final OnDaySelected onDaySelected;
  final void Function(DateTime focusedDay) onPageChanged; 
  DateTime? selectedDay;
  
  Calendar({required this.onDaySelected, required this.onPageChanged,required this.focusedDay,this.selectedDay,super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //* 월의 주 수에 따라서 Calendar 크기 조정
      height: CalendarUtils().getCalendarHeight(focusedDay),
      child: TableCalendar(
          //: 가능한 모든 높이 차지함
          shouldFillViewport: true,
          //: header 없앰
          headerVisible: false,

          focusedDay: focusedDay,
          firstDay: DateTime.now().subtract(Duration(days: 365 * 10)),
          lastDay: DateTime.now().add(Duration(days: 365 * 10)),
          selectedDayPredicate: (DateTime dateTime) {
            if (selectedDay == null) {
              return false;
            }

            return dateTime.year == selectedDay!.year &&
                dateTime.month == selectedDay!.month &&
                dateTime.day == selectedDay!.day;
          },
          onDaySelected: onDaySelected,
          onPageChanged: onPageChanged,
          calendarBuilders: _calendarBuilders()),
    );
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
            headerColor: Colors.purple,
            date: date);
      },
      todayBuilder: (context, date, focusedDay) {
        return _calendarBox(
            //totalExpenditure: totalExpenditure?[dateFormate_yyDDmm(date)],
            //totalIncome: totalIncome?[dateFormate_yyDDmm(date)],
            context: context,
            headerColor: Colors.blue,
            date: date);
      },
      defaultBuilder: (context, date, focusedDay) {
        return _calendarBox(
            //totalExpenditure: totalExpenditure?[dateFormate_yyDDmm(date)],
            //totalIncome: totalIncome?[dateFormate_yyDDmm(date)],
            context: context,
            headerColor: Colors.green,
            date: date);
      },
      outsideBuilder: (context, date, focusedDay) {
        return _calendarBox(
            //totalExpenditure: totalExpenditure?[dateFormate_yyDDmm(date)],
            //totalIncome: totalIncome?[dateFormate_yyDDmm(date)],
            context: context,
            headerColor: Colors.grey,
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
    required Color headerColor,
    required DateTime date,
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
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
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

