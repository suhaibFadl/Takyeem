import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takyeem/features/reports/Services/reports_service.dart';
import 'package:takyeem/features/reports/models/daily_record_status.dart';
import 'package:takyeem/features/reports/models/daily_record_type.dart';
import 'package:takyeem/features/reports/models/sheikh.dart';
import 'package:takyeem/features/reports/models/student_dily_record.dart';
import 'package:takyeem/features/reports/models/surah.dart';
import 'package:takyeem/features/students/models/student.dart';
import 'package:takyeem/features/students/service/studentService.dart';
import 'package:intl/intl.dart';
part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportsService reportsService;
  final StudentService studentService;

  late List<DailyRecordStatus> dailyRecordStatus;
  late List<DailyRecordType> dailyRecordType;
  late List<Student>? studentswithOutRecords;
  late List<Sheikh> sheikhs;
  late List<Surah> surahs;

  ReportBloc(this.reportsService, this.studentService)
      : super(ReportInitial()) {
    on<LoadMainDataEvent>(_loadMainData);
    on<AddDailyRecordEvent>(_addDailyRecord);
    on<LoadTodayRecordsEvent>(_onLoadTodayRecords);
    on<LoadStudentReportEvent>(_loadStudentReport);
    on<LoadRecordsByDateEvent>(_onLoadRecordsByDate);
  }

  Future<void> _loadMainData(event, emit) async {
    emit(ReportLoadingState());
    try {
      final isStudyDay = await reportsService.isTodayStudyDay();
      if (!isStudyDay) {
        emit(NotStudyDayState("لا يوجد تسميع اليوم"));
        return;
      }

      dailyRecordStatus = await reportsService.loadDailyRecordStatus();
      dailyRecordType = await reportsService.loadDailyRecordType();
      studentswithOutRecords =
          await reportsService.loadStudentsWithoutDailyRecord();
      sheikhs = await reportsService.loadSheikhs();
      surahs = await studentService.getAllSurahs();
      emit(ReportLoadedState(
        dailyRecordStatus,
        dailyRecordType,
        studentswithOutRecords,
        sheikhs,
        surahs,
      ));
    } catch (e) {
      debugPrint("******************${e.toString()}");
      emit(ReportErrorState(e.toString()));
    }
  }

  Future<void> _onLoadTodayRecords(
      LoadTodayRecordsEvent event, Emitter<ReportState> emit) async {
    await _loadRecordsForDate(DateTime.now(), emit);
  }

  Future<void> _onLoadRecordsByDate(
      LoadRecordsByDateEvent event, Emitter<ReportState> emit) async {
    await _loadRecordsForDate(event.date, emit);
  }

  Future<void> _loadRecordsForDate(
      DateTime date, Emitter<ReportState> emit) async {
    emit(ReportLoadingState());
    try {
      final bool isStudyDay = await reportsService.isStudyDay(date);
      if (!isStudyDay) {
        String formattedDate =
            DateFormat('EEEE, d MMMM yyyy', 'ar').format(date);
        emit(NotStudyDayState("اليوم المحدد ($formattedDate) ليس يوم دراسة"));
        return;
      }

      final records = await reportsService.getDailyRecordsForDate(date);
      emit(RecordsLoadedState(studentsRecords: records, selectedDate: date));
    } catch (e) {
      emit(ReportErrorState('حدث خطأ: ${e.toString()}'));
    }
  }

  Future<void> _addDailyRecord(event, emit) async {
    emit(ReportLoadingState());

    try {
      await reportsService.addDailyRecord(event.dailyRecord);
      var student = studentswithOutRecords
          ?.firstWhere((student) => student.id == event.dailyRecord.studentId);

      if (event.dailyRecord.type == "ثمن" &&
          student?.surah?.id != event.dailyRecord.surahId) {
        await studentService.updateStudentSurah(
            student!.id, event.dailyRecord.surahId!);
      }

      studentswithOutRecords
          ?.removeWhere((student) => student.id == event.dailyRecord.studentId);

      emit(ReportLoadedState(dailyRecordStatus, dailyRecordType,
          studentswithOutRecords, sheikhs, surahs));
    } catch (e) {
      debugPrint("******************${e.toString()}");
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
