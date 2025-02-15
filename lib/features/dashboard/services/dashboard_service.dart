import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardService {
  final firestore = FirebaseFirestore.instance;
  Future<int> getTotalStudents() async {
    final response = await firestore.collection('Students').get();
    return response.docs.length;
  }

  Future<int> getAttendances() async {
    DateTime toDate = DateTime.now();
    DateTime fromDate = DateTime(toDate.year, toDate.month, toDate.day, 0, 0);

    final response = await firestore
        .collection('StudentDailyRecord')
        .where('date',
            isGreaterThanOrEqualTo: fromDate
                .toIso8601String()) // Use gte for greater than or equal to
        .where('date', isLessThan: toDate.toIso8601String())
        .get();
    return response.docs.length;
  }

  Future<int> getTotalByType(String type) async {
    DateTime toDate = DateTime.now();
    DateTime fromDate = DateTime(toDate.year, toDate.month, toDate.day, 0, 0);
    final response = await firestore
        .collection('StudentsDailyRecords')
        .where('type', isEqualTo: type)
        .where('date',
            isGreaterThanOrEqualTo: fromDate
                .toIso8601String()) // Use gte for greater than or equal to
        .where('date', isLessThan: toDate.toIso8601String())
        .get();

    return response.docs.length;
  }
}
