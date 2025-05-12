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
    Set<String> recordedStudentIdsToday = {};

    final studentResponse = await _supabaseClient
        .from('Students')
        .select('*, Surah(*)')
        .eq('isActive', 'true')
        .order('surah_id', ascending: true);

    allActiveStudents =
        studentResponse.map((student) => Student.fromJson(student)).toList();

    final recordStream = _supabaseClient
        .from('StudentDailyRecord')
        .stream(primaryKey: ['id']).order('date', ascending: false);

    try {
      await for (final streamedData in recordStream) {
        final now = DateTime.now();
        final startOfToday = DateTime(now.year, now.month, now.day, 0, 0, 0);
        final startOfTomorrow =
            DateTime(now.year, now.month, now.day + 1, 0, 0, 0);

        recordedStudentIdsToday = streamedData
            .where((recordMap) {
              bool isToday = false;
              if (!recordMap.containsKey('date') ||
                  !recordMap.containsKey('student_id')) {
                return false;
              }
              try {
                final recordDate = DateTime.parse(recordMap['date'] as String);
                isToday = !recordDate.isBefore(startOfToday) &&
                    recordDate.isBefore(startOfTomorrow);
              } catch (e) {
                return false;
              }
              return isToday;
            })
            .map((recordMap) {
              final id = recordMap['student_id'];

              final stringId = (id is int) ? id.toString() : null;

              return stringId;
            })
            .where((id) => id != null)
            .cast<String>()
            .toSet();

        final studentsWithoutRecord = allActiveStudents.where((student) {
          final hasRecord =
              recordedStudentIdsToday.contains(student.id.toString());

          return !hasRecord;
        }).toList();

        yield studentsWithoutRecord.isEmpty ? null : studentsWithoutRecord;
      }
    } catch (e) {
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
        .select('*, Students(*, Surah(*)), DailyRecordType(name)')
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

    final response = await _supabaseClient
        .from('Study Days')
        .select('*')
        .eq('english_name', dayName);

    return response.isNotEmpty;
  }

  Future<List<StudentDailyRecord>> getDailyRecordsForDate(DateTime date) async {
    // Calculate the start and end of the given date
    final fromDate = DateTime(date.year, date.month, date.day);
    final toDate = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final response = await _supabaseClient
        .from('StudentDailyRecord')
        .select('*, Students(*, Surah(*)), DailyRecordType(name)')
        .gte('date', fromDate.toIso8601String())
        .lt('date', toDate.toIso8601String());
    // .order('student_id', ascending: true); // Keep or remove order as needed

    final records =
        response.map((record) => StudentDailyRecord.fromJson(record)).toList();

    return records;
  }

  Future<bool> isStudyDay(DateTime date) async {
    String dayName = DateFormat('EEEE', 'en_US').format(date);
    final response = await _supabaseClient
        .from('Study Days')
        .select('*')
        .eq('english_name', dayName)
        .limit(1);
    return response.isNotEmpty;
  }
}
