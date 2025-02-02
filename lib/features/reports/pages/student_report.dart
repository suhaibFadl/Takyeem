import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:takyeem/features/reports/blocs/bloc/report_bloc.dart';
import 'package:takyeem/features/reports/entities/hijri_months_list.dart';
import 'package:takyeem/widgets/dropdown/cubit/dropdown_cubit.dart';

class StudentReport extends StatelessWidget {
  StudentReport({super.key, required this.studentId});
  final int studentId;
  final _today = HijriCalendar.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "تقرير طالب",
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                  ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is ReportInitial) {
            context.read<ReportBloc>().add(LoadStudentReportEvent(studentId));
          }
          if (state is StudentReportState) {
            var student = state.student;

            // توفير Cubit لقائمة السنوات الهجرية
            return BlocProvider(
              create: (context) => DropdownCubit(state.hijriYears.last),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      // borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${student.firstName} ${student.fatherName} ${student.lastName}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                  ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                    0.2), // Adjust opacity for desired shadow intensity
                                offset: const Offset(2.0,
                                    2.0), // Adjust offset for shadow direction
                                blurRadius:
                                    5.0, // Adjust blurRadius for shadow softness
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "تاريخ الالتحاق: ${DateFormat('yyyy/MM/dd').format(student.joiningDate)}",
                              ),
                              Text(
                                "مقدار الحفظ: ${student.surah.name} ",
                                textAlign: TextAlign.end,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(32),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "النتائج الشهرية",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        const Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.search),
                            ),
                            BlocProvider(
                              create: (context) =>
                                  DropdownCubit(state.hijriYears.first),
                              child: BlocBuilder<DropdownCubit, dynamic>(
                                builder: (context, selectedYear) {
                                  return DropdownButton(
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    value: selectedYear,
                                    items: state.hijriYears
                                        .map((year) => DropdownMenuItem(
                                              value: year,
                                              child: Text(year.toString()),
                                            ))
                                        .toList(),
                                    onChanged: (dynamic newValue) {
                                      if (newValue != null) {
                                        context
                                            .read<DropdownCubit>()
                                            .onChanged(newValue);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            const Gap(10),
                            BlocProvider(
                              create: (context) =>
                                  DropdownCubit(_today.longMonthName),
                              child: BlocBuilder<DropdownCubit, dynamic>(
                                builder: (context, selectedMonth) {
                                  return DropdownButton(
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                    value: selectedMonth,
                                    items: hijriMonths
                                        .map((month) => DropdownMenuItem(
                                              value: month["الاسم"],
                                              child: Text(month["الاسم"]!),
                                            ))
                                        .toList(),
                                    onChanged: (dynamic newValue) {
                                      if (newValue != null) {
                                        context
                                            .read<DropdownCubit>()
                                            .onChanged(newValue);
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const Gap(32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width * .3,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.2), // Adjust opacity for desired shadow intensity
                                    offset: const Offset(2.0,
                                        2.0), // Adjust offset for shadow direction
                                    blurRadius:
                                        5.0, // Adjust blurRadius for shadow softness
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Gap(10),
                                  Text(
                                    "الحضور",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 26,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "10",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 32,
                                            ),
                                      ),
                                      Text(
                                        "من",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                            ),
                                      ),
                                      Text(
                                        "7",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontSize: 32,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "أيام",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontSize: 26,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width * .3,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.2), // Adjust opacity for desired shadow intensity
                                    offset: const Offset(2.0,
                                        2.0), // Adjust offset for shadow direction
                                    blurRadius:
                                        5.0, // Adjust blurRadius for shadow softness
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Gap(10),
                                  Text(
                                    "الحضور",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 26,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "10",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 32,
                                            ),
                                      ),
                                      Text(
                                        "من",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                            ),
                                      ),
                                      Text(
                                        "7",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontSize: 32,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "أيام",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontSize: 26,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width * .3,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.2), // Adjust opacity for desired shadow intensity
                                    offset: const Offset(2.0,
                                        2.0), // Adjust offset for shadow direction
                                    blurRadius:
                                        5.0, // Adjust blurRadius for shadow softness
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  const Gap(10),
                                  Text(
                                    "الحضور",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 26,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "10",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 32,
                                            ),
                                      ),
                                      Text(
                                        "من",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                            ),
                                      ),
                                      Text(
                                        "7",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontSize: 32,
                                            ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "أيام",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontSize: 26,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Gap(32),
                        Container(
                          // height: 150,
                          padding: const EdgeInsets.all(16.0),
                          width: MediaQuery.of(context).size.width * .9,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(
                                    0.2), // Adjust opacity for desired shadow intensity
                                offset: const Offset(2.0,
                                    2.0), // Adjust offset for shadow direction
                                blurRadius:
                                    5.0, // Adjust blurRadius for shadow softness
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "100 %",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 26,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                  ),
                                  const Gap(46),
                                  Text(
                                    "النسبة",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 26,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          if (state is ReportErrorState) {
            return Center(
              child: Text(state.error),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
