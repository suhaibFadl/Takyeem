part of 'dashboard_bloc.dart';

sealed class DashboardEvent {}

final class DashboardInitialEvent extends DashboardEvent {}

final class CreateNewMonthEvent extends DashboardEvent {
  final String monthName;
  final int year;
  final int shift;

  CreateNewMonthEvent(
      {required this.monthName, required this.year, required this.shift});
}
