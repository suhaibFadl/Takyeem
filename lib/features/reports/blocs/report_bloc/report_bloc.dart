import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takyeem/features/reports/Services/reports_service.dart';
import 'package:takyeem/features/reports/models/daily_record_status.dart';
import 'package:takyeem/features/reports/models/daily_record_type.dart';
import 'package:takyeem/features/reports/models/sheikh.dart';
import 'package:takyeem/features/reports/models/student_dily_record.dart';
import 'package:takyeem/features/reports/models/surah.dart';
import 'package:takyeem/features/students/models/student.dart';
import 'package:takyeem/features/students/service/studentService.dart';
import 'package:intl/intl.dart';
part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportsService reportsService;
  final StudentService studentService;

  // Store the stream subscription to manage it
  StreamSubscription? _studentsWithoutRecordSubscription;

  // No need to cache lists here anymore, they live in the state
  // late List<DailyRecordStatus> dailyRecordStatus;
  // late List<DailyRecordType> dailyRecordType;
  // List<Student>? studentswithOutRecords;
  // late List<Sheikh> sheikhs;
  // late List<Surah> surahs;

  ReportBloc(this.reportsService, this.studentService)
      : super(ReportInitial()) {
    on<LoadMainDataEvent>(_loadMainData);
    on<AddDailyRecordEvent>(_addDailyRecord);
    on<LoadTodayRecordsEvent>(_onLoadTodayRecords);
    on<LoadStudentReportEvent>(_loadStudentReport);
    on<LoadRecordsByDateEvent>(_onLoadRecordsByDate);
    on<_UpdateStudentsWithoutRecordEvent>(_onUpdateStudentsWithoutRecord);
    // --- Add handler for the search event ---
    on<SearchStudentsEvent>(_onSearchStudents);
  }

  // --- Helper function for filtering ---
  List<Student> _filterStudents(List<Student>? allStudents, String query) {
    if (allStudents == null || allStudents.isEmpty) return [];
    if (query.isEmpty) {
      return List.from(allStudents); // Return a copy
    } else {
      final lowerCaseQuery = query.toLowerCase().trim();
      return allStudents.where((student) {
        final fullName =
            "${student.firstName} ${student.fatherName} ${student.lastName}"
                .toLowerCase();
        return fullName.contains(lowerCaseQuery);
      }).toList();
    }
  }

  Future<void> _loadMainData(
      LoadMainDataEvent event, Emitter<ReportState> emit) async {
    // Don't emit loading if already loaded and just refreshing via pull-to-refresh
    if (state is! ReportLoadedState) {
      emit(ReportLoadingState());
    }

    try {
      // Cancel any existing subscription before fetching new data / starting new stream
      await _studentsWithoutRecordSubscription?.cancel();
      _studentsWithoutRecordSubscription = null;

      final isStudyDay = await reportsService.isTodayStudyDay();
      if (!isStudyDay) {
        emit(NotStudyDayState("لا يوجد تسميع اليوم"));
        return;
      }

      // --- Load one-time data AND Initial student list ---
      final results = await Future.wait<dynamic>([
        reportsService.loadDailyRecordStatus(),
        reportsService.loadDailyRecordType(),
        reportsService.loadSheikhs(),
        studentService.getAllSurahs(),
        // Use the Future-based method for the INITIAL list
        reportsService
            .loadStudentsWithoutDailyRecord()
            .first, // Convert Stream to Future
      ]);

      // Assign results directly to the state
      final initialStudentList = results[4] as List<Student>?;
      final initialFilteredList =
          _filterStudents(initialStudentList, ""); // Initially unfiltered

      emit(ReportLoadedState(
        dailyRecordStatus: results[0] as List<DailyRecordStatus>,
        dailyRecordType: results[1] as List<DailyRecordType>,
        sheikhs: results[2] as List<Sheikh>,
        surahs: results[3] as List<Surah>,
        allStudentsWithoutRecords: initialStudentList, // Full list
        filteredStudents: initialFilteredList, // Filtered list (initially same)
        currentSearchQuery: "", // Reset search query
      ));

      // --- NOW, start listening to the REAL-TIME stream ---
      // Correctly call the stream-returning method and listen to it
      _studentsWithoutRecordSubscription = reportsService
          .loadStudentsWithoutDailyRecord()
          .listen((updatedStudentList) {
        // .listen() is valid on a Stream
        // Add internal event to handle the update
        add(_UpdateStudentsWithoutRecordEvent(updatedStudentList));
      }, onError: (error, stackTrace) {
        // Handle stream errors (e.g., Supabase connection issue)
        debugPrint("Error in studentsWithoutRecord stream: $error");
        debugPrint("Stack trace: $stackTrace");
        // Optionally add an event to emit a specific error state from the BLoC
        // add(ReportStreamErrorEvent(error)); // Example
      });
    } catch (e, stackTrace) {
      // Catch errors during initial load
      debugPrint("Error loading main data: ${e.toString()}");
      debugPrint("Stack trace: $stackTrace");
      await _studentsWithoutRecordSubscription
          ?.cancel(); // Cancel if stream started before error
      _studentsWithoutRecordSubscription = null;
      emit(ReportErrorState(e.toString()));
    }
  }

  // Handler for internal stream updates
  void _onUpdateStudentsWithoutRecord(
      _UpdateStudentsWithoutRecordEvent event, Emitter<ReportState> emit) {
    // Only update if the current state is ReportLoadedState
    if (state is ReportLoadedState) {
      final currentState = state as ReportLoadedState;
      final newFullList = event.updatedList;
      // Re-apply the existing search filter to the new full list
      final newFilteredList =
          _filterStudents(newFullList, currentState.currentSearchQuery);

      emit(currentState.copyWith(
        allStudentsWithoutRecords: newFullList, // Update the full list
        filteredStudents: newFilteredList, // Update the filtered list
        // Keep other state fields (status, type, sheikhs, surahs, query)
      ));
    } else {
      // If not loaded, the next LoadMainData will handle the list.
      debugPrint(
          "Received stream update while not in ReportLoadedState. Ignoring.");
    }
  }

  // --- Handler for Search Event ---
  void _onSearchStudents(SearchStudentsEvent event, Emitter<ReportState> emit) {
    if (state is ReportLoadedState) {
      final currentState = state as ReportLoadedState;
      final newFilteredList =
          _filterStudents(currentState.allStudentsWithoutRecords, event.query);

      emit(currentState.copyWith(
        filteredStudents: newFilteredList, // Update only filtered list
        currentSearchQuery: event.query, // Update the query
        // Keep other state fields the same (full list, status, etc.)
      ));
    }
  }

  Future<void> _onLoadTodayRecords(
      LoadTodayRecordsEvent event, Emitter<ReportState> emit) async {
    await _studentsWithoutRecordSubscription?.cancel();
    _studentsWithoutRecordSubscription = null;
    await _loadRecordsForDate(DateTime.now(), emit);
  }

  Future<void> _onLoadRecordsByDate(
      LoadRecordsByDateEvent event, Emitter<ReportState> emit) async {
    await _studentsWithoutRecordSubscription?.cancel();
    _studentsWithoutRecordSubscription = null;
    await _loadRecordsForDate(event.date, emit);
  }

  Future<void> _loadStudentReport(
      LoadStudentReportEvent event, Emitter<ReportState> emit) async {
    await _studentsWithoutRecordSubscription?.cancel();
    _studentsWithoutRecordSubscription = null;
    // ... rest of method
// ... existing code ...
  }

  Future<void> _loadRecordsForDate(
      DateTime date, Emitter<ReportState> emit) async {
    // ... (implementation should be okay) ...
// ... existing code ...
  }

  Future<void> _addDailyRecord(
      AddDailyRecordEvent event, Emitter<ReportState> emit) async {
    try {
      await reportsService.addDailyRecord(event.dailyRecord);
    } catch (e) {
      emit(ReportErrorState(e.toString()));
    }
    // --- Option 2: Keep Optimistic Update (but update both lists) ---
    if (state is ReportLoadedState) {
      final currentState = state as ReportLoadedState;
      final studentIdToRemove = event.dailyRecord.studentId;

      // Create copies to modify
      List<Student> updatedAllStudents =
          List.from(currentState.allStudentsWithoutRecords ?? []);
      List<Student> updatedFilteredStudents =
          List.from(currentState.filteredStudents);

      // Remove from both lists
      // updatedAllStudents
      //     .removeWhere((student) => student.id == studentIdToRemove);
      // updatedFilteredStudents
      //     .removeWhere((student) => student.id == studentIdToRemove);

      // Emit optimistically updated state
      emit(currentState.copyWith(
        allStudentsWithoutRecords: updatedAllStudents,
        filteredStudents: updatedFilteredStudents,
      ));

      try {
        // Perform the actual DB operation
        // await reportsService.addDailyRecord(event.dailyRecord);
        ;
        // Surah Update Logic (use original list for finding student if needed)
        var student = currentState.allStudentsWithoutRecords?.firstWhere(
            (s) => s.id == event.dailyRecord.studentId,
            orElse: () => throw Exception('Student not found'));
        if (event.dailyRecord.type == "ثمن" &&
            student?.surah?.id != event.dailyRecord.surahId &&
            event.dailyRecord.surahId != null) {
          await studentService.updateStudentSurah(
              student!.id, event.dailyRecord.surahId!);
        }

        // Stream update will follow to confirm the state.
      } catch (e, stackTrace) {
        debugPrint("Error adding daily record: ${e.toString()}");
        debugPrint("Stack trace: $stackTrace");
        // Emit error state. Consider reverting the optimistic update here if needed.
        emit(ReportErrorState(e.toString()));
        // Revert optimistic update by re-emitting previous state or reloading
        // emit(currentState); // Simple revert (might cause flicker)
      }
    } else {
      // Handle case where state is not loaded (e.g., emit loading/error)
      emit(ReportLoadingState()); // Or handle appropriately
      try {
        debugPrint(
            "event.dailyRecord: ${event.dailyRecord.type}, ${event.dailyRecord.typeId}");
        await reportsService.addDailyRecord(event.dailyRecord);
        // Maybe trigger a reload after adding if state wasn't loaded
        add(LoadMainDataEvent());
      } catch (e) {
        emit(ReportErrorState(e.toString()));
      }
    }
  }

  // --- IMPORTANT: Dispose of the stream subscription ---
  @override
  Future<void> close() {
    _studentsWithoutRecordSubscription?.cancel();
    return super.close();
  }
}
