import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:takyeem/features/reports/Services/reports_service.dart';
import 'package:takyeem/features/reports/models/daily_record_status.dart';
import 'package:takyeem/features/reports/models/daily_record_type.dart';
import 'package:takyeem/features/reports/models/sheikh.dart';
import 'package:takyeem/features/reports/models/student_dily_record.dart';
import 'package:takyeem/features/students/models/student.dart';
import 'package:takyeem/features/students/service/studentService.dart';
part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportsService reportsService;
  final StudentService studentService;

  late List<DailyRecordStatus> dailyRecordStatus;
  late List<DailyRecordType> dailyRecordType;
  late List<Student>? studentswithOutRecords;
  late List<Sheikh> sheikhs;

  ReportBloc(this.reportsService, this.studentService)
      : super(ReportInitial()) {
    on<LoadMainDataEvent>((event, emit) async {
      emit(ReportLoadingState());
      try {
        dailyRecordStatus = await reportsService.loadDailyRecordStatus();
        dailyRecordType = await reportsService.loadDailyRecordType();
        studentswithOutRecords =
            await reportsService.loadStudentsWithoutDailyRecord();
        sheikhs = await reportsService.loadSheikhs();
        emit(ReportLoadedState(
          dailyRecordStatus,
          dailyRecordType,
          studentswithOutRecords,
          sheikhs,
        ));
      } catch (e) {
        emit(ReportErrorState(e.toString()));
      }
    });

    on<AddDailyRecordEvent>((event, emit) async {
      emit(ReportLoadingState());

      try {
        await reportsService.addDailyRecord(event.dailyRecord);
        studentswithOutRecords?.removeWhere(
            (student) => student.id == event.dailyRecord.studentId);

        emit(ReportLoadedState(dailyRecordStatus, dailyRecordType,
            studentswithOutRecords, sheikhs));
      } catch (e) {
        emit(ReportErrorState(e.toString()));
      }
    });
    on<LoadTodayRecordsEvent>(_loadTodayRecords);
    on<LoadStudentReportEvent>(_loadStudentReport);
  }

  Future<void> _loadTodayRecords(event, emit) async {
    emit(ReportLoadingState());
    try {
      final records = await reportsService.getAllTodayRecords();
      emit(TodayRecordsState(records));
    } catch (e) {
      emit(ReportErrorState(e.toString()));
    }
  }

  Future<void> _loadStudentReport(event, emit) async {
    emit(ReportLoadingState());
    try {
      final years = await reportsService.loadHijriYears();

      final student = await reportsService.getStudentReport(event.studentId);
      emit(StudentReportState(
        student,
        years,
      ));
    } catch (e) {
      emit(ReportErrorState(e.toString()));
    }
  }
}
