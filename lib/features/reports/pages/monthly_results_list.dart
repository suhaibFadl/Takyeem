import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:takyeem/features/reports/blocs/student_monthly_reports/student_monthly_reports_bloc.dart';
import 'package:takyeem/features/reports/blocs/students_bloc/students_bloc.dart';
import 'package:takyeem/features/reports/blocs/students_bloc/students_event.dart';
import 'package:takyeem/features/reports/blocs/students_bloc/students_state.dart';
import 'package:takyeem/features/reports/pages/student_report.dart';

class MonthlyResultsList extends StatelessWidget {
  const MonthlyResultsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        // centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "النتائج الشهرية",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<StudentsBloc, StudentsState>(
          builder: (context, state) {
            log("state: $state");
            if (state is StudentsInitialState) {
              context.read<StudentsBloc>().add(GetAllStudents());
            }
            if (state is StudentsLoadingState) {
              return LoadingIndicator(
                indicatorType: Indicator.ballClipRotatePulse,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                strokeWidth: 2,
                backgroundColor: Colors.transparent,
                pathBackgroundColor: Colors.transparent,
              );
            } else if (state is StudentsLoadedState) {
              return state.students.isEmpty
                  ? Center(
                      child: Text(
                        "لا يوجد طلبة",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: state.students.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                // padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(10),
                                  // border: Border.all(
                                  //   color: Theme.of(context).colorScheme.primary,
                                  // ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.05), // Shadow color
                                      offset: const Offset(
                                          0, 4), // Shadow offset (x, y)
                                      blurRadius: 2, // Shadow blur radius
                                      spreadRadius: 1, // Shadow spread radius
                                    ),
                                  ],
                                ),
                                height: 65,
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    context
                                        .read<StudentMonthlyReportsBloc>()
                                        .add(LoadStudentInformationEvent(
                                            state.students[index].id));
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider.value(
                                          value: context.read<
                                              StudentMonthlyReportsBloc>(),
                                          child: StudentReport(
                                            studentId: state.students[index].id,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "${state.students[index].firstName} ${state.students[index].lastName}",
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
            } else if (state is StudentsErrorState) {}
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
