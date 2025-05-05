import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart'; // For @immutable
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:takyeem/features/reports/Services/reports_service.dart';
import 'package:takyeem/features/reports/models/student_dily_record.dart';
import 'package:takyeem/features/students/models/student.dart'; // Assuming model import

part 'view_daily_records_event.dart';
part 'view_daily_records_state.dart';

class ViewDailyRecordsBloc
    extends Bloc<ViewDailyRecordsEvent, ViewDailyRecordsState> {
  final ReportsService reportsService;
  ViewDailyRecordsBloc(this.reportsService) : super(ViewDailyRecordsInitial()) {
    on<LoadRecordsEvent>(_onLoadRecords);
    on<SearchDailyRecordsEvent>(_onSearchRecords); // Register search handler
  }

  // --- Helper function for filtering ---
  List<StudentDailyRecord> _filterRecords(
      List<StudentDailyRecord>? allRecords, String query) {
    if (allRecords == null || allRecords.isEmpty) return [];
    if (query.isEmpty) {
      return List.from(allRecords); // Return a copy
    } else {
      final lowerCaseQuery = query.toLowerCase().trim();
      return allRecords.where((record) {
        // Handle potential null student
        final student = record.student;
        if (student == null) return false; // Skip records without student data

        final fullName =
            "${student.firstName} ${student.fatherName ?? ''} ${student.lastName}" // Handle potential null fatherName
                .toLowerCase();
        return fullName.contains(lowerCaseQuery);
      }).toList();
    }
  }

  Future<void> _onLoadRecords(
      LoadRecordsEvent event, Emitter<ViewDailyRecordsState> emit) async {
    emit(ViewDailyRecordsLoadingState());
    try {
      final bool isStudyDay = await reportsService.isStudyDay(event.date);
      if (!isStudyDay) {
        String formattedDate =
            DateFormat('EEEE, d MMMM yyyy', 'ar').format(event.date);
        emit(NotStudyDayState("اليوم المحدد ($formattedDate) ليس يوم دراسة"));
        return;
      }

      final records = await reportsService.getDailyRecordsForDate(event.date);
      // Apply initial empty filter
      final filteredRecords = _filterRecords(records, "");

      emit(ViewDailyRecordsLoadedState(
        allStudentsRecords: records, // Full list
        filteredStudentsRecords:
            filteredRecords, // Filtered list (initially same)
        selectedDate: event.date,
        currentSearchQuery: "", // Reset query on new load
      ));
    } catch (e) {
      emit(ViewDailyRecordsErrorState(
          'حدث خطأ أثناء تحميل السجلات: ${e.toString()}'));
    }
  }

  // --- Handler for Search Event ---
  void _onSearchRecords(
      SearchDailyRecordsEvent event, Emitter<ViewDailyRecordsState> emit) {
    if (state is ViewDailyRecordsLoadedState) {
      final currentState = state as ViewDailyRecordsLoadedState;
      // Filter the *full* list based on the new query
      final newFilteredList =
          _filterRecords(currentState.allStudentsRecords, event.query);

      emit(currentState.copyWith(
        filteredStudentsRecords: newFilteredList, // Update only filtered list
        currentSearchQuery: event.query, // Update the query
        // Keep other state fields the same (full list, date)
      ));
    }
    // If not in loaded state, do nothing for search
  }
}
