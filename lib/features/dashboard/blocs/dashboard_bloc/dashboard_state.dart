part of 'dashboard_bloc.dart';

sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoadingState extends DashboardState {}

final class DashboardLoadedState extends DashboardState {
  Today today;
  int totalStudents;
  int attendances;
  int helga;
  int thomon;
  int horuf;
  int absentees;
  Map<String, ViewTypeEntity>? totalByTypeList;
  DashboardLoadedState({
    required this.today,
    required this.totalStudents,
    required this.attendances,
    required this.absentees,
    required this.helga,
    required this.thomon,
    required this.horuf,
    required this.totalByTypeList,
  });
}

final class CreateNewMonthState extends DashboardState {}

final class DashboardErrorState extends DashboardState {
  final String error;

  DashboardErrorState({required this.error});
}
