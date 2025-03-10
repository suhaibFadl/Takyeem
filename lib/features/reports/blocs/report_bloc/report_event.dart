part of 'report_bloc.dart';

sealed class ReportEvent {}

final class LoadMainDataEvent extends ReportEvent {}

final class LoadTodayRecordsEvent extends ReportEvent {}

final class LoadStudentReportEvent extends ReportEvent {
  final int studentId;

  LoadStudentReportEvent(this.studentId);
}

final class LoadHijriMonthEvent extends ReportEvent {
  final int year;

  LoadHijriMonthEvent(this.year);
}

final class AddDailyRecordEvent extends ReportEvent {
  final StudentDailyRecord dailyRecord;

  AddDailyRecordEvent(this.dailyRecord);
}
