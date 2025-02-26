part of 'report_bloc.dart';

@immutable
sealed class ReportState {}

final class ReportInitial extends ReportState {}

final class ReportLoadingState extends ReportState {}

final class ReportLoadedState extends ReportState {
  final List<DailyRecordStatus> dailyRecordStatus;
  final List<DailyRecordType> dailyRecordType;
  final List<Student>? studentswithOutRecords;
  final List<Sheikh> sheikhs;

  ReportLoadedState(
    this.dailyRecordStatus,
    this.dailyRecordType,
    this.studentswithOutRecords,
    this.sheikhs,
  );
}

final class TodayRecordsState extends ReportState {
  final List<StudentDailyRecord>? studentsRecords;

  TodayRecordsState(this.studentsRecords);
}

final class StudentReportState extends ReportState {
  final Student student;
  final List<int> hijriYears;

  StudentReportState(
    this.student,
    this.hijriYears,
  );

  StudentReportState copyWith({
    Student? student,
    List<int>? hijriYears,
  }) {
    return StudentReportState(
      student ?? this.student,
      hijriYears ?? this.hijriYears,
    );
  }
}

final class ReportError extends ReportState {}

final class ReportErrorState extends ReportState {
  final String error;

  ReportErrorState(this.error);
}
