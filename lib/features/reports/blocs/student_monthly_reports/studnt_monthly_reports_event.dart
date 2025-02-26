part of 'student_monthly_reports_bloc.dart';

@immutable
sealed class StudentMonthlyReportsEvent {}

class LoadStudentInformationEvent extends StudentMonthlyReportsEvent {
  final int studentId;

  LoadStudentInformationEvent(this.studentId);
}

class LoadStudentMonthlyReportsEvent extends StudentMonthlyReportsEvent {}
