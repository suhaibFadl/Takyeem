import 'package:takyeem/features/students/models/student.dart';

abstract class StudentEvent {}

class AddNewStudentEvent extends StudentEvent {}

class SendStudentDataEvent extends StudentEvent {
  final Student student;

  SendStudentDataEvent({required this.student});
}
