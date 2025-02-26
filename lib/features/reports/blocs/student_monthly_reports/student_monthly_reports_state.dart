part of 'student_monthly_reports_bloc.dart';

@immutable
sealed class StudentMonthlyReportsState {}

final class StudentMonthlyReportsInitial extends StudentMonthlyReportsState {}

final class StudentMonthlyReportsLoading extends StudentMonthlyReportsState {}

final class StudentMonthlyReportsLoaded extends StudentMonthlyReportsState {
  final Student student;
  final List<int> hijriYears;

  StudentMonthlyReportsLoaded(this.student, this.hijriYears);

  StudentMonthlyReportsLoaded copyWith({
    Student? student,
    List<int>? hijriYears,
  }) {
    return StudentMonthlyReportsLoaded(
      student ?? this.student,
      hijriYears ?? this.hijriYears,
    );
  }
}

final class StudentMonthlyReportsError extends StudentMonthlyReportsState {
  final String message;

  StudentMonthlyReportsError(this.message);
}
