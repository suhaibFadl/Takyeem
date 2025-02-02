import 'package:takyeem/features/students/models/student.dart';

abstract class StudentEvent {}

class GetAllStudents extends StudentEvent {}

class AddStudentEvent extends StudentEvent {
  final Student student;

  AddStudentEvent({required this.student});
}
