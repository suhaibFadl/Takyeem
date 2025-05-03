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
  final List<Surah> surahs;

  ReportLoadedState(
    this.dailyRecordStatus,
    this.dailyRecordType,
    this.studentswithOutRecords,
    this.sheikhs,
    this.surahs,
  );
}

class RecordsLoadedState extends ReportState {
  final List<StudentDailyRecord>? studentsRecords;
  final DateTime selectedDate;

  RecordsLoadedState(
      {required this.studentsRecords, required this.selectedDate});

  @override
  List<Object?> get props => [studentsRecords, selectedDate];
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

final class NotStudyDayState extends ReportState {
  final String message;

  NotStudyDayState(this.message);
}

final class ReportErrorState extends ReportState {
  final String error;

  ReportErrorState(this.error);
}
