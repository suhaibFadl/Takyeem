import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takyeem/features/students/bloc/student_event.dart';
import 'package:takyeem/features/students/bloc/student_state.dart';
import 'package:takyeem/features/students/service/studentService.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentService studentService;

  StudentBloc(this.studentService) : super(StudentInitialState()) {
    on<AddNewStudentEvent>((event, emit) async {
      emit(StudentLoadingState());
      try {
        final surahs = await studentService.getAllSurahs();
        emit(AddNewStudentState(surahs: surahs));
      } catch (e) {
        emit(StudentErrorState(error: e.toString()));
      }
    });

    on<SendStudentDataEvent>((event, emit) async {
      emit(StudentLoadingState());
      try {
        await studentService.addStudent(event.student);
        emit(StudentAddedState(student: event.student));
      } catch (e) {
        emit(StudentErrorState(error: e.toString()));
      }
    });
  }
}
