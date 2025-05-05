part of 'report_bloc.dart';

@immutable
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

// Event to load records for a specific date
class LoadRecordsByDateEvent extends ReportEvent {
  final DateTime date;

  LoadRecordsByDateEvent({required this.date});

  // @override
  // List<Object> get props => [date];
}

class _UpdateStudentsWithoutRecordEvent extends ReportEvent {
  final List<Student>? updatedList;
  _UpdateStudentsWithoutRecordEvent(this.updatedList);

  @override
  List<Object?> get props => [updatedList];
}

// --- Add Search Event ---
final class SearchStudentsEvent extends ReportEvent {
  final String query;

  SearchStudentsEvent(this.query);

  @override
  List<Object?> get props => [query];
}
