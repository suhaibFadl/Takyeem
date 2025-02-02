import 'package:bloc/bloc.dart';
import 'package:hijri/hijri_calendar.dart';
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
  late int helga;
  late int thomon;
  late int horuf;
  late Today? _today;

  DashboardBloc(this._dashboardService) : super(DashboardInitial()) {
    on<DashboardInitialEvent>((event, emit) async {
      emit(DashboardLoadingState());
      try {
        _today = await DateGate().getHijriDate(DateTime.now());

        if (_today == null) emit(CreateNewMonthState());

        totalStudents = await _dashboardService.getTotalStudents();
        attendances = await _dashboardService.getAttendances();
        helga = await _dashboardService.getTotalByType('حلقة');
        thomon = await _dashboardService.getTotalByType('ثمن');
        horuf = await _dashboardService.getTotalByType('حروف');

        emit(
          DashboardLoadedState(
            today: _today!,
            totalStudents: totalStudents,
            attendances: attendances,
            helga: helga,
            thomon: thomon,
            horuf: horuf,
          ),
        );
      } catch (e) {
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
