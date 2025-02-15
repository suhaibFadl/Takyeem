import 'package:takyeem/features/reports/models/student_dily_record.dart';
import 'package:takyeem/features/reports/models/surah.dart';

class Student {
  final int id;
  final String firstName;
  final String fatherName;
  final String lastName;
  final DateTime bornDate;
  final DateTime joiningDate;
  final String phoneNumber;
  final String quardianPhoneNumber;
  final List<StudentDailyRecord>? studentDailyRecords;
  // final int surahId;
  final Surah surah;
  bool isActive = true;

  Student({
    required this.id,
    required this.firstName,
    required this.fatherName,
    required this.lastName,
    required this.bornDate,
    required this.joiningDate,
    required this.phoneNumber,
    required this.quardianPhoneNumber,
    required this.isActive,
    // required this.surahId,
    required this.surah,
    this.studentDailyRecords,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'father_name': fatherName,
      'last_name': lastName,
      'born_date': bornDate.toIso8601String(),
      'joining_date': joiningDate.toIso8601String(),
      'phone_number': phoneNumber,
      'quardian_phone_number': quardianPhoneNumber,
      'isActive': isActive,
      // 'surah_id': surahId,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    print("heeeere: ${json['surah']}");
    return Student(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? 'Unknown',
      fatherName: json['father_name'] ?? 'Unknown',
      lastName: json['last_name'] ?? 'Unknown',
      bornDate: json['born_date'].toDate(),
      joiningDate: json['joining_date'].toDate(),
      phoneNumber: json['phone_number'] ?? 'Unknown',
      quardianPhoneNumber: json['quardian_phone_number'] ?? 'Unknown',
      isActive: json['isActive'] ?? true,
      studentDailyRecords: json['StudentDailyRecord'] != null
          ? StudentDailyRecord.fromJsonList(json['StudentDailyRecord'])
          : [],
      surah: Surah.fromJson(json['surah']),
    );
  }
}
