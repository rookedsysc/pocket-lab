import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pocket_lab/calendar/component/month_header.dart';
import 'package:pocket_lab/calendar/component/week_header.dart';
import 'package:pocket_lab/calendar/model/calendar_model.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
import 'package:pocket_lab/calendar/utils/calendar_utils.dart';
import 'package:pocket_lab/calendar/view/calendar_screen.dart';
import 'package:pocket_lab/common/component/custom_skeletone.dart';
import 'package:pocket_lab/common/util/custom_number_utils.dart';
import 'package:pocket_lab/common/util/date_utils.dart';
import 'package:pocket_lab/home/component/home_screen/transaction_button.dart';
import 'package:pocket_lab/transaction/model/transaction_model.dart';
import 'package:pocket_lab/transaction/repository/transaction_repository.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends ConsumerStatefulWidget {
  const Calendar({super.key});

  @override
  ConsumerState<Calendar> createState() => _CalendarState();
}

class _CalendarState extends ConsumerState<Calendar> {
  late StreamSubscription transactionSubscription;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late CalendarModel _calendarState;
  
  @override
  Widget build(BuildContext context) {
    initRiverpod();



    return SizedBox(
      //* 월의 주 수에 따라서 Calendar 크기 조정
      height: CalendarUtils().getCalendarHeight(_focusedDay),
      child: StreamBuilder<List<Transaction>>(
        stream: ref.watch(transactionRepositoryProvider.notifier).getThisMonthTransactions(_focusedDay),
        builder: (context, snapshot) {

          if(snapshot.data == null) {
            return CustomSkeletone().square(width: MediaQuery.of(context).size.width, height: CalendarUtils().getCalendarHeight(_focusedDay));
          }
          
          return TableCalendar(
              //: 가능한 모든 높이 차지함
              shouldFillViewport: true,
              //: header 없앰
              headerVisible: false,
              focusedDay: _focusedDay,
              firstDay: DateTime.now().subtract(Duration(days: 365 * 1000)),
              lastDay: DateTime.now().add(Duration(days: 365 * 1000)),
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
              calendarBuilders: _calendarBuilders(snapshot.data!));
        }
      ),
    );
  }

  double? getTotal(DateTime date,{required List<Transaction> transactions,required TransactionType type}) {
    double? total;

    for(Transaction _transaction in transactions) {
      if(_transaction.transactionType == type && CustomDateUtils().isSameDay(_transaction.date, date)) {
        if(total == null) {
          total = 0;
        }
        total += _transaction.amount;
      }
    }

    return total;
  }

  void initRiverpod() {
    _calendarState = ref.watch(calendarProvider);
    _focusedDay = _calendarState.focusedDay;
    if (_calendarState.selectedDay != null) {
      _selectedDay = _calendarState.selectedDay;
    }
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

  CalendarBuilders _calendarBuilders(List<Transaction> transactions) {
    const TextStyle _weekendTextStyle =
        TextStyle(color: Colors.red, fontSize: 12);
    return CalendarBuilders(
      selectedBuilder: (context, date, focusedDay) {
        return _calendarBox(
            totalExpenditure: getTotal(date, type: TransactionType.expenditure, transactions: transactions),
            totalIncome: getTotal(date, type: TransactionType.income, transactions: transactions),
            context: context,
            // 다크 모드에선 흰색 글씨 라이트 모드에선 검은색 글씨
            date: date);
      },
      todayBuilder: (context, date, focusedDay) {
        return _calendarBox(
            totalExpenditure: getTotal(date, type: TransactionType.expenditure, transactions: transactions),
            totalIncome: getTotal(date, type: TransactionType.income, transactions: transactions),
            context: context,
            textColor: Colors.blue,
            date: date);
      },
      defaultBuilder: (context, date, focusedDay) {
        return _calendarBox(
            totalExpenditure: getTotal(date, type: TransactionType.expenditure, transactions: transactions),
            totalIncome: getTotal(date, type: TransactionType.income, transactions: transactions),
            context: context,
            date: date);
      },
      outsideBuilder: (context, date, focusedDay) {
        return _calendarBox(
            totalExpenditure: getTotal(date, type: TransactionType.expenditure, transactions: transactions),
            totalIncome: getTotal(date, type: TransactionType.income, transactions: transactions),
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
    double? totalIncome,
    double? totalExpenditure,
  }) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                    CustomNumberUtils.formatCurrency(totalIncome),
                    style: TextStyle(fontSize: 8, color: Theme.of(context).textTheme.bodyLarge?.color),
                  ),
                if (totalExpenditure != null)
                  Text(
                    CustomNumberUtils.formatCurrency(totalExpenditure),
                    style: TextStyle(fontSize: 8, color: Colors.red),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

