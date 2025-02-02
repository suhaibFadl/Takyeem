import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takyeem/features/students/bloc/student_event.dart';
import 'package:takyeem/features/students/bloc/student_state.dart';
import 'package:takyeem/features/students/service/studentService.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentService studentService;

  StudentBloc(this.studentService) : super(StudentInitialState()) {
    on<AddStudentEvent>((event, emit) async {
      emit(StudentLoadingState());
      try {
        await studentService.addStudent(event.student);
        emit(StudentAddedState(student: event.student));
      } catch (e) {
        emit(StudentErrorState(error: e.toString()));
      }
    });

    on<GetAllStudents>((event, emit) async {
      emit(StudentLoadingState());
      try {
        final students = await studentService.getAllStudents();
        emit(StudentsLoadedState(students: students));
      } catch (e) {
        emit(StudentErrorState(error: e.toString()));
      }
    });
  }
}
