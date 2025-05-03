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

  Future<List<Student>?> loadStudentsWithoutDailyRecord() async {
    final studentResponse = await _supabaseClient
        .from('Students')
        .select('*, Surah(*)')
        .eq('isActive', 'true')
        .order('surah_id', ascending: true);

    DateTime toDate = DateTime.now();
    DateTime fromDate = DateTime(toDate.year, toDate.month, toDate.day, 0, 0);

    final dailyRecordResponse = await _supabaseClient
        .from('StudentDailyRecord')
        .select('*')
        .gte('date',
            fromDate.toIso8601String()) // Use gte for greater than or equal to
        .lt('date', toDate.toIso8601String());
    final students = studentResponse
        .map((item) {
          var student = Student.fromJson(item);
          bool hasDailyRecord = dailyRecordResponse.any((record) =>
              StudentDailyRecord.fromJson(record).studentId == student.id);
          return hasDailyRecord ? null : student;
        })
        .where((student) => student != null)
        .cast<Student>()
        .toList();
    return students.isEmpty ? null : students;
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
