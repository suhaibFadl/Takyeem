part of 'view_daily_records_bloc.dart';

@immutable
sealed class ViewDailyRecordsState {}

final class ViewDailyRecordsInitial extends ViewDailyRecordsState {}

final class ViewDailyRecordsLoadingState extends ViewDailyRecordsState {}

final class ViewDailyRecordsLoadedState extends ViewDailyRecordsState {
  // Keep the original full list
  final List<StudentDailyRecord>? allStudentsRecords;
  // Add the list for filtered results
  final List<StudentDailyRecord> filteredStudentsRecords;
  final DateTime selectedDate;
  // Store the current query
  final String currentSearchQuery;

  ViewDailyRecordsLoadedState({
    required this.allStudentsRecords,
    required this.filteredStudentsRecords,
    required this.selectedDate,
    this.currentSearchQuery = "", // Default empty query
  });

  // Helper copyWith method
  ViewDailyRecordsLoadedState copyWith({
    List<StudentDailyRecord>? allStudentsRecords,
    List<StudentDailyRecord>? filteredStudentsRecords,
    DateTime? selectedDate,
    String? currentSearchQuery,
  }) {
    return ViewDailyRecordsLoadedState(
      allStudentsRecords: allStudentsRecords ?? this.allStudentsRecords,
      filteredStudentsRecords:
          filteredStudentsRecords ?? this.filteredStudentsRecords,
      selectedDate: selectedDate ?? this.selectedDate,
      currentSearchQuery: currentSearchQuery ?? this.currentSearchQuery,
    );
  }

  @override
  List<Object?> get props => [
        allStudentsRecords,
        filteredStudentsRecords,
        selectedDate,
        currentSearchQuery,
      ];
}

final class ViewDailyRecordsErrorState extends ViewDailyRecordsState {
  final String message;
  ViewDailyRecordsErrorState(this.message);
}

final class NotStudyDayState extends ViewDailyRecordsState {
  final String message;
  NotStudyDayState(this.message);
}
