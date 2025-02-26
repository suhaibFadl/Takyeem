import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:takyeem/features/reports/Services/reports_service.dart';
import 'package:takyeem/features/students/models/student.dart';
import 'package:takyeem/features/students/service/studentService.dart';

part 'studnt_monthly_reports_event.dart';
part 'student_monthly_reports_state.dart';

class StudentMonthlyReportsBloc
    extends Bloc<StudentMonthlyReportsEvent, StudentMonthlyReportsState> {
  final ReportsService reportsService;
  final StudentService studentService;
  StudentMonthlyReportsBloc(this.reportsService, this.studentService)
      : super(StudentMonthlyReportsInitial()) {
    on<LoadStudentInformationEvent>(_loadStudentReport);
  }

  Future<void> _loadStudentReport(event, emit) async {
    emit(StudentMonthlyReportsLoading());
    try {
      final years = await reportsService.loadHijriYears();

      final student = await reportsService.getStudentReport(event.studentId);
      emit(StudentMonthlyReportsLoaded(
        student,
        years,
      ));
    } catch (e) {
      emit(StudentMonthlyReportsError(e.toString()));
    }
  }
}
