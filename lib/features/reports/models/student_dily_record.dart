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
  StudentDailyRecord({
    this.id,
    required this.studentId,
    required this.type,
    required this.status,
    required this.sheikh,
    required this.date,
    required this.note,
    this.student,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'type': type,
      'status': status,
      'sheikh': sheikh,
      'date': date.toIso8601String(),
      'note': note,
    };
  }

  factory StudentDailyRecord.fromJson(Map<String, dynamic> json) {
    return StudentDailyRecord(
      id: json['id'],
      studentId: json['student_id'],
      type: json['type'],
      status: json['status'],
      sheikh: json['sheikh'],
      date: json['date'] is String
          ? DateTime.parse(json['date'])
          : DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      note: json['note'],
      student:
          json['Students'] != null ? Student.fromJson(json['Students']) : null,
    );
  }

  static List<StudentDailyRecord> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => StudentDailyRecord.fromJson(json)).toList();
  }
}
