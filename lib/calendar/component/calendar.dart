import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/calendar/model/calendar_model.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
import 'package:pocket_lab/calendar/utils/calendar_utils.dart';
import 'package:pocket_lab/calendar/view/transaction_detail_view.dart';
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
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late CalendarModel _calendarState;

  @override
  void didChangeDependencies() {
    initRiverpod();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _focusedDay = ref.watch(calendarProvider).focusedDay;
    return SizedBox(
      //* 월의 주 수에 따라서 Calendar 크기 조정
      height: CalendarUtils().getCalendarHeight(_focusedDay),
      child: StreamBuilder<List<Transaction>>(
          stream: ref
              .watch(transactionRepositoryProvider.notifier)
              .getSelectMonthTransactions(_focusedDay),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return CustomSkeletone().square(
                  width: MediaQuery.of(context).size.width,
                  height: CalendarUtils().getCalendarHeight(_focusedDay));
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
          }),
    );
  }

  double? getTotal(DateTime date,
      {required List<Transaction> transactions,
      required TransactionType type}) {
    double? total;

    for (Transaction _transaction in transactions) {
      if (_transaction.transactionType == type &&
          CustomDateUtils().isSameDay(_transaction.date, date)) {
        if (total == null) {
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
      if (mounted) {
        setState(() {
          ref.read(calendarProvider.notifier).setSelectedDay(selectedDay);
          ref.read(calendarProvider.notifier).setFocusedDay(selectedDay);
        });
      }
    };
  }

  void Function(DateTime focusedDay) _onPageChanged() {
    return (focusedDay) {
      debugPrint("[*] onPageChaged : ${focusedDay.toString()}");
      if (mounted) {
        setState(() {
          _focusedDay = focusedDay;
          ref.read(calendarProvider.notifier).setFocusedDay(focusedDay);
        });
      }
    };
  }

  CalendarBuilders _calendarBuilders(List<Transaction> transactions) {
    const TextStyle _weekendTextStyle =
        TextStyle(color: Colors.red, fontSize: 12);
    return CalendarBuilders(
      selectedBuilder: (context, date, focusedDay) {
        return _CalendarBox(date: date);
      },
      todayBuilder: (context, date, focusedDay) {
        return _CalendarBox(date: date, textColor: Colors.blue);
      },
      defaultBuilder: (context, date, focusedDay) {
        return _CalendarBox(
          date: date,
        );
      },
      outsideBuilder: (context, date, focusedDay) {
        return _CalendarBox(date: date, textColor: Colors.grey);
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
}

///* 일자를 넣으면 해당 일자의 total income, total expenditure를 보여주는 위젯
class _CalendarBox extends ConsumerStatefulWidget {
  final DateTime date;
  final Color? textColor;
  const _CalendarBox({this.textColor, required this.date});

  @override
  ConsumerState<_CalendarBox> createState() => _CalendarBoxState();
}

class _CalendarBoxState extends ConsumerState<_CalendarBox> {
  double totalIncome = 0;
  double totalExpenditure = 0;
  List<Transaction> _transaction = [];
  late StreamSubscription transactionSubscription;

  @override
  void didChangeDependencies() {
    final transactionStream = ref
        .watch(transactionRepositoryProvider.notifier)
        .getTransactionByPeriod(widget.date, widget.date);
    transactionSubscription = transactionStream.listen((events) {
      totalExpenditure = 0;
      totalIncome = 0;
      _transaction = events;
      for (Transaction event in events) {
        if (event.transactionType == TransactionType.income) {
          totalIncome += event.amount;
        } else if (event.transactionType == TransactionType.expenditure) {
          totalExpenditure += event.amount;
        }
      }
      if (mounted) {
        setState(() {});
      }
    });
    super.didChangeDependencies();
  }

  @override
  dispose() {
    transactionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _transaction.isNotEmpty
          ? () {
              CupertinoScaffold.showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => Consumer(
                  builder: (context, _consumerRef, child) {
                  return TransactionDetailView(
                    startDate: widget.date,
                    endDate: widget.date,
                    title: "",
                  );
                }
                ),
              );
            }
          : null,
      child: Container(
        margin: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        width: MediaQuery.of(context).size.width / 7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.date.day.toString(),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    color: widget.textColor ??
                        Theme.of(context).textTheme.bodyMedium?.color,
                  ),
              textAlign: TextAlign.center,
            ),

            //: 오늘 수입/지출
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (totalIncome != 0)
                    Text(
                      "+${CustomNumberUtils.formatNumber(totalIncome)}",
                      style: TextStyle(
                          fontSize: 9,
                          color: Theme.of(context).textTheme.bodyLarge?.color),
                    ),
                  SizedBox(
                    height: 4.0,
                  ),
                  if (totalExpenditure != 0)
                    Text(
                      "-${CustomNumberUtils.formatNumber(totalExpenditure)}",
                      style: TextStyle(fontSize: 9, color: Colors.red),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
