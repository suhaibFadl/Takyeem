import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takyeem/features/reports/blocs/students_bloc/students_event.dart';
import 'package:takyeem/features/reports/blocs/students_bloc/students_state.dart';
import 'package:takyeem/features/students/service/studentService.dart';

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  final StudentService studentService;

  StudentsBloc(this.studentService) : super(StudentsInitialState()) {
    on<GetAllStudents>((event, emit) async {
      emit(StudentsLoadingState());
      try {
        final students = await studentService.getAllStudents();
        emit(StudentsLoadedState(students: students));
      } catch (e) {
        emit(StudentsErrorState(error: e.toString()));
      }
    });
  }
}
