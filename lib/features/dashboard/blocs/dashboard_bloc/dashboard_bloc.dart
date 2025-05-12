import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:takyeem/features/dashboard/entities/view_type.dart';
import 'package:takyeem/features/dashboard/services/dashboard_service.dart';
import 'package:takyeem/features/date/date_gate.dart';
import 'package:takyeem/features/date/date_service.dart';
import 'package:takyeem/features/date/models/hijri_month.dart';
import 'package:takyeem/features/date/models/today.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService _dashboardService;

  late int totalStudents = 0;
  late int attendances;
  late int absentees;
  late int helga;
  late int thomon;
  late int horuf;
  late Today? _today;
  late Map<String, ViewTypeEntity>? totalByTypeList;

  DashboardBloc(this._dashboardService) : super(DashboardInitial()) {
    on<DashboardInitialEvent>((event, emit) async {
      emit(DashboardLoadingState());
      try {
        _today = await DateGate().getHijriDate(DateTime.now());
        log("_today: $_today");
        if (_today == null) emit(CreateNewMonthState());
        // await _dashboardService.populateTypeIdsFromTypeNames();
        totalStudents = await _dashboardService.getTotalStudents();
        attendances = await _dashboardService.getAttendances();
        absentees = await _dashboardService.getAbsentees();
        helga = await _dashboardService.getTotalByType('حلقة');
        thomon = await _dashboardService.getTotalByType('ثمن');
        horuf = await _dashboardService.getTotalByType('حروف');
        totalByTypeList = await _dashboardService.getTotalByTypeList();

        debugPrint("totalByTypeList: $totalByTypeList");
        emit(
          DashboardLoadedState(
            today: _today!,
            totalStudents: totalStudents,
            attendances: attendances,
            absentees: absentees,
            helga: helga,
            thomon: thomon,
            horuf: horuf,
            totalByTypeList: totalByTypeList,
          ),
        );
      } catch (e) {
        log(e.toString());
        emit(DashboardErrorState(error: e.toString()));
      }
    });

    on<CreateNewMonthEvent>((event, emit) async {
      emit(DashboardLoadingState());
      try {
        final tomorrow =
            HijriCalendar.fromDate(DateTime.now().add(const Duration(days: 1)));

        await DateService().createNewMonth(HijriMonth(
          name: event.monthName,
          year: tomorrow.hYear,
          shift: event.shift,
        ));

        // _today = await DateGate().getHijriDate(DateTime.now());
        emit(DashboardInitial());
      } catch (e) {
        emit(DashboardErrorState(error: e.toString()));
      }
    });
  }
}
