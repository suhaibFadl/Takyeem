import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:takyeem/features/auth/auth_gate.dart';
import 'package:takyeem/features/dashboard/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:takyeem/features/dashboard/services/dashboard_service.dart';
import 'package:takyeem/features/reports/Services/reports_service.dart';
import 'package:takyeem/features/reports/blocs/report_bloc/report_bloc.dart';
import 'package:takyeem/features/reports/blocs/student_monthly_reports/student_monthly_reports_bloc.dart';
import 'package:takyeem/features/reports/blocs/students_bloc/students_bloc.dart';
import 'package:takyeem/features/students/bloc/student_bloc.dart';
import 'package:takyeem/features/students/service/studentService.dart';
import 'package:takyeem/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  const locale = 'ar';
  HijriCalendar.setLocal(locale);

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => StudentBloc(StudentService()),
        ),
        BlocProvider(
          create: (context) => ReportBloc(ReportsService(), StudentService()),
        ),
        BlocProvider(
          create: (context) => DashboardBloc(DashboardService()),
        ),
        BlocProvider(
          create: (context) => StudentMonthlyReportsBloc(
            ReportsService(),
            StudentService(),
          ),
        ),
        BlocProvider(
          create: (context) => StudentsBloc(StudentService()),
        ),
      ],
      child: MaterialApp(
        title: 'تقييم',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthGate(),
      ),
    );
  }
}
