import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takyeem/features/reports/models/daily_record_status.dart';
import 'package:takyeem/features/reports/models/daily_record_type.dart';
import 'package:takyeem/features/reports/models/sheikh.dart';
import 'package:takyeem/features/reports/models/student_dily_record.dart';
import 'package:takyeem/features/students/models/student.dart';

class ReportsService {
  final firestore = FirebaseFirestore.instance;
  Future<List<DailyRecordStatus>> loadDailyRecordStatus() async {
    final response = await firestore.collection('DailyRecordsStatus').get();
    print("response: ${response.docs[0].data()}");
    return response.docs
        .map((e) => DailyRecordStatus.fromJson(e.data()))
        .toList();
  }

  Future<List<DailyRecordType>> loadDailyRecordType() async {
    final response = await firestore.collection('DailyRecordType').get();
    return response.docs
        .map((type) => DailyRecordType.fromJson(type.data()))
        .toList();
  }

  Future<List<Sheikh>> loadSheikhs() async {
    final response = await firestore.collection('Sheikh').get();
    return response.docs
        .map((sheikh) => Sheikh.fromJson(sheikh.data()))
        .toList();
  }

  Future<List<Student>?> loadStudentsWithoutDailyRecord() async {
    final studentResponse = await firestore
        .collection('Students')
        .where('isActive', isEqualTo: true)
        .get();

    DateTime toDate = DateTime.now();
    DateTime fromDate = DateTime(toDate.year, toDate.month, toDate.day, 0, 0);

    final dailyRecordResponse = await firestore
        .collection('StudentDailyRecord')
        .where('date', isGreaterThanOrEqualTo: fromDate.toIso8601String())
        .where('date', isLessThan: toDate.toIso8601String())
        .get();

    // ✅ Use Future.wait() with null filtering
    List<Student> students = (await Future.wait(
      studentResponse.docs.map((item) async {
        Map<String, dynamic> studentData = item.data();

        // Fetch the Surah document
        DocumentReference<Map<String, dynamic>> surahRef = studentData['surah'];
        DocumentSnapshot<Map<String, dynamic>> surahSnapshot =
            await surahRef.get();

        // ✅ Replace 'surah' reference with actual Surah object
        studentData['surah'] = surahSnapshot.data();

        // Create Student object
        Student student = Student.fromJson(studentData);

        // Check if student has a daily record
        bool hasDailyRecord = dailyRecordResponse.docs.any((record) =>
            StudentDailyRecord.fromJson(record.data()).studentId == student.id);

        return hasDailyRecord ? null : student;
      }).toList(),
    ))
        .whereType<Student>() // ✅ Remove null values safely
        .toList();

    return students.isEmpty ? null : students;
  }

  Future<void> addDailyRecord(StudentDailyRecord dailyRecord) async {
    await firestore
        .collection('StudentDailyRecord')
        .doc()
        .set(dailyRecord.toJson());
  }

  Future<Student> getStudentRecord(int id) async {
    try {
      final response = await firestore
          .collection('Students')
          .where('id', isEqualTo: id)
          .get();

      // Check if the response is not empty
      if (response.docs.isNotEmpty) {
        return Student.fromJson(
            response.docs[0].data()); // Pass the first record
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
    final response = await firestore
        .collection('StudentDailyRecord')
        .where('date',
            isGreaterThanOrEqualTo: fromDate
                .toIso8601String()) // Use gte for greater than or equal to
        .where('date', isLessThan: toDate.toIso8601String())
        .get();
    return response.docs
        .map((record) => StudentDailyRecord.fromJson(record.data()))
        .toList();
  }

  Future<Student> getStudentReport(int id) async {
    final response =
        await firestore.collection('Students').where('id', isEqualTo: id).get();

    return Student.fromJson(response.docs[0].data());
  }

  Future<List<int>> loadHijriYears() async {
    final response = await firestore.collection('hijri_months').get();
    return response.docs
        .map((month) => month.data()['year'] as int)
        .toSet()
        .toList();
  }

  Future<List<String>> loadHijriMonthsbyYear(int year) async {
    final response = await firestore
        .collection('hijri_months')
        .where('year', isEqualTo: year)
        .get();
    return response.docs
        .map((month) => month.data()['name'] as String)
        .toList();
  }
}
