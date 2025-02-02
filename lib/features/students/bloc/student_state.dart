import 'package:takyeem/features/students/models/student.dart';

class StudentState {}

class StudentInitialState extends StudentState {}

class StudentLoadingState extends StudentState {}

class StudentsLoadedState extends StudentState {
  final List<Student> students;

  StudentsLoadedState({required this.students});
}

class StudentAddedState extends StudentState {
  final Student student;

  StudentAddedState({required this.student});
}

class StudentErrorState extends StudentState {
  final String error;

  StudentErrorState({required this.error});
}
