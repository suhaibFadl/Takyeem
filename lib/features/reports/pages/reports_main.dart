import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:takyeem/features/reports/blocs/report_bloc/report_bloc.dart';
import 'package:takyeem/features/reports/blocs/students_bloc/students_bloc.dart';
import 'package:takyeem/features/reports/blocs/students_bloc/students_event.dart';
import 'package:takyeem/features/reports/pages/add_daily_records.dart';
import 'package:takyeem/features/reports/pages/monthly_results_list.dart';
import 'package:takyeem/features/reports/pages/view_daily_records.dart';
import 'package:takyeem/features/students/bloc/student_bloc.dart';
import 'package:takyeem/features/students/bloc/student_event.dart';

class ReportsMain extends StatelessWidget {
  const ReportsMain({super.key});

  @override
  Widget build(BuildContext context) {
    final reportBloc = context.read<ReportBloc>();
    return Scaffold(
      appBar: AppBar(
        // centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "التقارير",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Gap(32),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
                top: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
              ),
            ),
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () {
                reportBloc.add(LoadMainDataEvent());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<ReportBloc>(),
                      child: const AddDailyRecords(),
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    "إضافة التقارير اليومية",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
              ),
            ),
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () {
                reportBloc.add(LoadTodayRecordsEvent());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<ReportBloc>(),
                      child: const ViewDailyRecords(),
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    "عرض التقارير اليومية",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ),
              ),
            ),
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: TextButton(
              onPressed: () {
                context.read<StudentsBloc>().add(GetAllStudents());
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: context.read<ReportBloc>(),
                      child: const MonthlyResultsList(),
                    ),
                  ),
                );
              },
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    "عرض النتائج الشهرية",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
