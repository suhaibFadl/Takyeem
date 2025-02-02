import 'package:flutter/material.dart';
import 'package:takyeem/features/reports/Services/reports_service.dart';
import 'package:takyeem/features/students/models/student.dart';

class TestPage extends StatelessWidget {
  final ReportsService reportsService = ReportsService();

  TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: FutureBuilder<Student>(
        future: reportsService.getStudentRecord(27),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Show loading indicator while waiting
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}')); // Handle error
          } else if (snapshot.hasData) {
            final student = snapshot.data!;
            return Column(
              children: [
                Text(
                    'Number of students: ${student.firstName} ${student.studentDailyRecords?.length}'), // Display length
                Expanded(
                  // Wrap ListView in Expanded
                  child: ListView.builder(
                    itemCount: student.studentDailyRecords?.length,
                    itemBuilder: (context, index) {
                      return Text(student.studentDailyRecords != null &&
                              student.studentDailyRecords!.isNotEmpty
                          ? student.studentDailyRecords![0].status
                          : "no records"); // Assuming Student has a name property
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(
                child: Text('No students found')); // Handle empty case
          }
        },
      ),
    );
  }
}
