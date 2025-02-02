import 'package:flutter/material.dart';
import 'package:takyeem/features/reports/models/student_dily_record.dart';

class StudentDailyReportEntity {
  late int studentId;
  late TextEditingController note = TextEditingController();
  String? sheikh;
  String? status;
  String? type;
  late DateTime date;

  StudentDailyRecord toDailyRecord() {
    return StudentDailyRecord(
      studentId: studentId,
      note: note.text,
      sheikh: sheikh!,
      status: status!,
      type: type!,
      date: date,
    );
  }
}
