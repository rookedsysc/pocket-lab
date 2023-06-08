import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pocket_lab/calendar/component/calendar.dart';
import 'package:pocket_lab/calendar/component/month_header.dart';
import 'package:pocket_lab/calendar/component/month_pickcer.dart';
import 'package:pocket_lab/calendar/layout/week_header_layout.dart';
import 'package:pocket_lab/calendar/model/calendar_model.dart';
import 'package:pocket_lab/calendar/provider/calendar_provider.dart';
import 'package:pocket_lab/common/constant/ad_unit_id.dart';
import 'package:pocket_lab/common/provider/payment_status_provider.dart';
import 'package:pocket_lab/common/widget/banner_ad_container.dart';
import 'dart:io' show Platform;

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  // ignore: unused_field
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

    return Material(
        child: CupertinoScaffold(
          body: Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            body: SafeArea(
              top: true,
              child: Stack(
                children: [
                  ListView(
                    children: [
                      MonthPicker(),
                      MonthHeader(),
                      WeekHeaderLayOut(focusedDay: _focusedDay),
                      Padding(
                        padding: const EdgeInsets.only(top: 24, right: 8, left: 8),
                        child: Calendar(),
                      ),
                      if(!ref.watch(paymentStatusProvider))SizedBox(height: 50,)
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: BannerAdContainer(
                      adUnitId: Platform.isAndroid
                          ? CALENDAR_PAGE_BANNER_AOS
                          : CALENDAR_PAGE_BANNER_IOS),
                ),
              ],
            ),
            ),
          ),
        ),
    );
  }

  void initRiverpod() {
    _calendarState = ref.watch(calendarProvider);
    _focusedDay = _calendarState.focusedDay;
    if (_calendarState.selectedDay != null) {
      _selectedDay = _calendarState.selectedDay;
    }
  }
}
