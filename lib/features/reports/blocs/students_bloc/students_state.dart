import 'package:takyeem/features/students/models/student.dart';

class StudentsState {}

class StudentsInitialState extends StudentsState {}

class StudentsLoadingState extends StudentsState {}

class StudentsLoadedState extends StudentsState {
  final List<Student> students;

  StudentsLoadedState({required this.students});
}

class StudentsErrorState extends StudentsState {
  final String error;

  StudentsErrorState({required this.error});
}
