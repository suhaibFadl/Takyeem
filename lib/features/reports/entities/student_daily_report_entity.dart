import 'package:flutter/material.dart';
import 'package:takyeem/features/reports/models/student_dily_record.dart';

class StudentDailyReportEntity {
  late int studentId;
  late TextEditingController note = TextEditingController();
  String? sheikh;
  String? status;
  String? type;
  int? surahId;
  late DateTime date;

  StudentDailyRecord toDailyRecord() {
    debugPrint(
        "heeeere : ${studentId}, ${note.text}, ${sheikh}, ${status}, ${type}, ${surahId}, ${date}");
    return StudentDailyRecord(
      studentId: studentId,
      note: note.text,
      sheikh: sheikh!,
      status: status!,
      type: type!,
      date: date,
      surahId: surahId,
    );
  }
}
