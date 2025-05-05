import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takyeem/features/reports/models/daily_record_status.dart';
import 'package:takyeem/features/reports/models/daily_record_type.dart';
import 'package:takyeem/features/reports/models/sheikh.dart';
import 'package:takyeem/features/reports/models/student_dily_record.dart';
import 'package:takyeem/features/students/models/student.dart';

class ReportsService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<List<DailyRecordStatus>> loadDailyRecordStatus() async {
    final response =
        await _supabaseClient.from('DailyRecordStatus').select('*');
    return response.map((e) => DailyRecordStatus.fromJson(e)).toList();
  }

  Future<List<DailyRecordType>> loadDailyRecordType() async {
    final response = await _supabaseClient.from('DailyRecordType').select('*');
    return response.map((type) => DailyRecordType.fromJson(type)).toList();
  }

  Future<List<Sheikh>> loadSheikhs() async {
    final response = await _supabaseClient.from('Sheikh').select('*');
    return response.map((sheikh) => Sheikh.fromJson(sheikh)).toList();
  }

  Stream<List<Student>?> loadStudentsWithoutDailyRecord() async* {
    List<Student> allActiveStudents = [];
    Set<String> recordedStudentIdsToday =
        {}; // Store IDs of students recorded today

    final studentResponse = await _supabaseClient
        .from('Students')
        .select('*, Surah(*)')
        .eq('isActive', 'true')
        .order('surah_id', ascending: true);

    allActiveStudents =
        studentResponse.map((student) => Student.fromJson(student)).toList();

    DateTime toDate = DateTime.now();
    DateTime fromDate = DateTime(toDate.year, toDate.month, toDate.day, 0, 0);

    final recordStream = _supabaseClient.from('StudentDailyRecord').stream(
            primaryKey: [
          'id'
        ]) // Use actual primary key(s) for StudentDailyRecord
        .order('date', ascending: false); // Optional ordering

    try {
      await for (final streamedData in recordStream) {
        // --- Start Debug ---
        debugPrint(
            "[Stream Debug] Received stream update with ${streamedData.length} records.");
        // --- End Debug ---

        // Determine date range for "today" within the loop
        final now = DateTime.now();
        final startOfToday = DateTime(now.year, now.month, now.day, 0, 0, 0);
        final startOfTomorrow =
            DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
        // --- Start Debug ---
        debugPrint(
            "[Stream Debug] Date Range: $startOfToday to $startOfTomorrow");
        // --- End Debug ---

        // Re-calculate the set of recorded student IDs for today (as Strings)
        recordedStudentIdsToday = streamedData
            .where((recordMap) {
              bool isToday = false; // Flag to track if record is for today
              if (!recordMap.containsKey('date') ||
                  !recordMap.containsKey('student_id')) {
                // --- Start Debug ---
                debugPrint(
                    "[Stream Debug] Record skipped (missing keys): $recordMap");
                // --- End Debug ---
                return false;
              }
              try {
                final recordDate = DateTime.parse(recordMap['date'] as String);
                isToday = !recordDate.isBefore(startOfToday) &&
                    recordDate.isBefore(startOfTomorrow);
                // --- Add Specific Debug for the problematic Student ID (replace '100' if needed) ---
                if (recordMap['student_id']?.toString() == '100') {
                  // Replace '100' with the actual ID
                  debugPrint(
                      "[Stream Debug] Checking record for Student 100: Date=$recordDate, IsToday=$isToday");
                }
                // --- End Debug ---
              } catch (e) {
                // --- Start Debug ---
                debugPrint(
                    "[Stream Debug] Error parsing date for record: $recordMap, Error: $e");
                // --- End Debug ---
                return false; // Skip records with parse errors
              }
              return isToday; // Return the flag
            })
            .map((recordMap) {
              final id = recordMap['student_id'];
              // Cast to int?, then convert to String if not null
              final stringId = (id is int) ? id.toString() : null;
              // --- Add Specific Debug for the problematic Student ID (replace '100' if needed) ---
              if (id?.toString() == '100') {
                // Replace '100' with the actual ID
                debugPrint(
                    "[Stream Debug] Converting ID for Student 100: Original=$id, String=$stringId");
              }
              // --- End Debug ---
              return stringId;
            })
            .where((id) => id != null) // Filter out nulls
            .cast<String>() // Now contains Strings
            .toSet();

        // --- Start Debug ---
        debugPrint(
            "[Stream Debug] Calculated Today's Recorded IDs: $recordedStudentIdsToday");
        // Add Specific Check if the problematic ID is in the Set
        if (recordedStudentIdsToday.contains('100')) {
          // Replace '100' with the actual ID
          debugPrint("[Stream Debug] Set CONFIRMED to contain '100'");
        } else {
          debugPrint("[Stream Debug] Set DOES NOT contain '100'");
        }
        // --- End Debug ---

        // Filter the *cached* list of all active students
        final studentsWithoutRecord = allActiveStudents
            // Compare student.id (String) with the set of Strings
            .where((student) {
          final hasRecord =
              recordedStudentIdsToday.contains(student.id.toString());
          // --- Add Specific Debug for the problematic Student ID (replace '100' if needed) ---
          if (student.id == '100') {
            // Replace '100' with the actual ID
            debugPrint(
                "[Stream Debug] Filtering Student 100: ID=${student.id}, HasRecord=$hasRecord, ShouldAppear=${!hasRecord}");
          }
          // --- End Debug ---
          return !hasRecord; // Return true if student should appear (no record)
        }).toList();

        // --- Start Debug ---
        debugPrint(
            "[Stream Debug] Yielding Students Without Records: ${studentsWithoutRecord.map((s) => s.id).toList()}");
        // --- End Debug ---

        // Yield the latest calculated list
        yield studentsWithoutRecord.isEmpty ? null : studentsWithoutRecord;
      }
    } catch (e) {
      debugPrint(
          'Error in streamStudentsWithoutDailyRecord stream processing: $e');
      // Yield an error state to the listener (Bloc)
      yield* Stream.error(Exception('Stream processing failed: $e'));
    }
  }

  Future<void> addDailyRecord(StudentDailyRecord dailyRecord) async {
    await _supabaseClient
        .from('StudentDailyRecord')
        .insert(dailyRecord.toJson());
  }

  Future<Student> getStudentRecord(int id) async {
    try {
      final response = await _supabaseClient
          .from('Students')
          .select('*, StudentDailyRecord (*)')
          .eq('id', id);
      // Check if the response is not empty
      if (response.isNotEmpty) {
        return Student.fromJson(response[0]); // Pass the first record
      } else {
        throw Exception('No student found with the given ID');
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<StudentDailyRecord>> getAllTodayRecords() async {
    DateTime toDate = DateTime.now();
    DateTime fromDate = DateTime(toDate.year, toDate.month, toDate.day, 0, 0);
    final response = await _supabaseClient
        .from('StudentDailyRecord')
        .select('*, Students(*, Surah(*))')
        .gte('date', fromDate.toIso8601String())
        .lt('date', toDate.toIso8601String())
        .order('surah_id', ascending: true);

    var records =
        response.map((record) => StudentDailyRecord.fromJson(record)).toList();

    return records;
  }

  Future<Student> getStudentReport(int id) async {
    final response = await _supabaseClient
        .from('Students')
        .select('*, Surah(*)')
        .eq('id', id);

    return Student.fromJson(response[0]);
  }

  Future<List<int>> loadHijriYears() async {
    final response = await _supabaseClient.from('hijri_months').select('*');
    return response.map((month) => month['year'] as int).toSet().toList();
  }

  Future<List<String>> loadHijriMonthsbyYear(int year) async {
    final response =
        await _supabaseClient.from('hijri_months').select('*').eq('year', year);
    return response.map((month) => month['name'] as String).toList();
  }

  Future<bool> isTodayStudyDay() async {
    String dayName = DateFormat('EEEE').format(DateTime.now());
    debugPrint("******************${dayName}");
    final response = await _supabaseClient
        .from('Study Days')
        .select('*')
        .eq('english_name', dayName);
    debugPrint("******************${response}");
    return response.isNotEmpty;
  }

  Future<List<StudentDailyRecord>> getDailyRecordsForDate(DateTime date) async {
    // Calculate the start and end of the given date
    final fromDate = DateTime(date.year, date.month, date.day);
    final toDate = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final response = await _supabaseClient
        .from('StudentDailyRecord')
        .select('*, Students(*, Surah(*))')
        // Use the provided date range
        .gte('date', fromDate.toIso8601String())
        .lt('date', toDate.toIso8601String());
    // .order('student_id', ascending: true); // Keep or remove order as needed

    // Check if the response is not empty and is a list
    if (response != null && response is List) {
      final records = response
          .map((record) => StudentDailyRecord.fromJson(record))
          .toList();

      // Optional: Sort in Dart if DB sorting is complex/not working
      // records.sort((a, b) => (a.student?.surahId ?? 0).compareTo(b.student?.surahId ?? 0));

      return records;
    } else {
      // Handle cases where response is null or not a list
      return []; // Return an empty list or throw an error
    }
  }

  Future<bool> isStudyDay(DateTime date) async {
    String dayName = DateFormat('EEEE', 'en_US')
        .format(date); // Ensure consistent locale if needed
    final response = await _supabaseClient
        .from('Study Days') // Make sure table name is correct
        .select('*')
        .eq('english_name', dayName)
        .limit(1); // Optimization: only need to know if one exists
    return response.isNotEmpty;
  }
}
