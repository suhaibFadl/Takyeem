part of 'report_bloc.dart';

@immutable
sealed class ReportState {}

final class ReportInitial extends ReportState {}

final class ReportLoadingState extends ReportState {}

final class ReportLoadedState extends ReportState {
  final List<DailyRecordStatus> dailyRecordStatus;
  final List<DailyRecordType> dailyRecordType;
  final List<Student>? allStudentsWithoutRecords;
  final List<Student> filteredStudents;
  final List<Sheikh> sheikhs;
  final List<Surah> surahs;
  final String currentSearchQuery;

  ReportLoadedState({
    required this.dailyRecordStatus,
    required this.dailyRecordType,
    required this.allStudentsWithoutRecords,
    required this.filteredStudents,
    required this.sheikhs,
    required this.surahs,
    this.currentSearchQuery = "",
  });

  ReportLoadedState copyWith({
    List<DailyRecordStatus>? dailyRecordStatus,
    List<DailyRecordType>? dailyRecordType,
    List<Student>? allStudentsWithoutRecords,
    List<Student>? filteredStudents,
    List<Sheikh>? sheikhs,
    List<Surah>? surahs,
    String? currentSearchQuery,
  }) {
    return ReportLoadedState(
      dailyRecordStatus: dailyRecordStatus ?? this.dailyRecordStatus,
      dailyRecordType: dailyRecordType ?? this.dailyRecordType,
      allStudentsWithoutRecords:
          allStudentsWithoutRecords ?? this.allStudentsWithoutRecords,
      filteredStudents: filteredStudents ?? this.filteredStudents,
      sheikhs: sheikhs ?? this.sheikhs,
      surahs: surahs ?? this.surahs,
      currentSearchQuery: currentSearchQuery ?? this.currentSearchQuery,
    );
  }

  @override
  List<Object?> get props => [
        dailyRecordStatus,
        dailyRecordType,
        allStudentsWithoutRecords,
        filteredStudents,
        sheikhs,
        surahs,
        currentSearchQuery,
      ];
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
