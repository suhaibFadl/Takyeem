import 'package:takyeem/features/reports/models/surah.dart';
import 'package:takyeem/features/students/models/student.dart';

class StudentDailyRecord {
  late int? id;
  late int studentId;
  late String type;
  late String status;
  late String sheikh;
  late String note;
  late DateTime date;
  late Student? student;
  late int? surahId;
  late Surah? surah;
  late int typeId;

  StudentDailyRecord({
    this.id,
    required this.studentId,
    required this.type,
    required this.status,
    required this.sheikh,
    required this.date,
    required this.note,
    required this.typeId,
    this.student,
    this.surahId,
    this.surah,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'type': type,
      'status': status,
      'sheikh': sheikh,
      'date': date.toIso8601String(),
      'note': note,
      'surah_id': surahId,
      'type_id': typeId,
    };
  }

  factory StudentDailyRecord.fromJson(Map<String, dynamic> json) {
    return StudentDailyRecord(
      id: json['id'],
      studentId: json['student_id'],
      type: json['DailyRecordType']['name'],
      status: json['status'],
      sheikh: json['sheikh'],
      date: json['date'] is String
          ? DateTime.parse(json['date'])
          : DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      note: json['note'],
      student:
          json['Students'] != null ? Student.fromJson(json['Students']) : null,
      surah: json['surah'] != null ? Surah.fromJson(json['surah']) : null,
      typeId: json['type_id'],
    );
  }

  static List<StudentDailyRecord> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => StudentDailyRecord.fromJson(json)).toList();
  }
}
