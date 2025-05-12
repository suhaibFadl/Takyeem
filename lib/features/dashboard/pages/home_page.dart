import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';
import 'package:gap/gap.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:takyeem/features/auth/auth_service.dart';
import 'package:takyeem/features/dashboard/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:takyeem/features/dashboard/pages/create_new_month.dart';
import 'package:takyeem/features/dashboard/widgets/pie_chart.dart';
import 'package:takyeem/features/reports/blocs/view_daily_records_bloc/view_daily_records_bloc.dart';
import 'package:takyeem/features/reports/pages/view_daily_records.dart';

import '../../reports/blocs/report_bloc/report_bloc.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final authService = AuthService();

  Future<void> signOut() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<DashboardBloc>().add((DashboardInitialEvent()));
    // });
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                onPressed: signOut,
                icon: const Icon(Icons.logout),
              ),
            ),
            Text(
              'الصفحة الرئيسية',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            // const Gap(40),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardInitial) {
              context.read<DashboardBloc>().add((DashboardInitialEvent()));
            }
            if (state is DashboardLoadingState) {
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
            }
            if (state is DashboardLoadedState) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RefreshIndicator(
                  onRefresh: () async {
                    context
                        .read<DashboardBloc>()
                        .add((DashboardInitialEvent()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        const Gap(12),
                        Text(
                          textDirection: TextDirection.rtl,
                          '${state.today.week_day}, ${state.today.day} ${state.today.month_name}  ${state.today.year} هـ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),

                        const Gap(12),
                        InnerShadow(
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 18,
                              offset: Offset(10, 2),
                            )
                          ],
                          child: Container(
                            // padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withAlpha(20), // 0.3 * 255 ≈ 76
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceAround, // Center the chart
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${state.totalStudents}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        Gap(4),
                                        Text('العدد الكلي'),
                                        Gap(4),
                                        Container(
                                          width: 10,
                                          height: 10,
                                          color: const Color.fromARGB(
                                              154, 158, 158, 158),
                                        ),
                                      ],
                                    ),
                                    Gap(12),
                                    Row(
                                      children: [
                                        Text(
                                          "${state.attendances}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        Gap(4),
                                        Text('الحضور'),
                                        Gap(4),
                                        Container(
                                          width: 10,
                                          height: 10,
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                    Gap(12),
                                    Row(
                                      children: [
                                        Text(
                                          "${state.absentees}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        Gap(4),
                                        Text('الغياب'),
                                        Gap(4),
                                        Container(
                                          width: 10,
                                          height: 10,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 200, // Fixed height
                                  // width: MediaQuery.of(context).size.width *
                                  //     0.8, // Fixed width
                                  child: PieChartSample2(
                                    primaryTitle: 'الحضور',
                                    secondaryTitle: 'الغياب',
                                    primaryValue: state.totalStudents > 0
                                        ? (state.attendances /
                                                state.totalStudents *
                                                100)
                                            .roundToDouble()
                                        : 0,
                                    secondaryValue: state.totalStudents > 0
                                        ? ((state.absentees) /
                                                state.totalStudents *
                                                100)
                                            .roundToDouble()
                                        : 0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Container(
                        //   padding: const EdgeInsets.symmetric(vertical: 12),
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(12),
                        //     color: Theme.of(context).colorScheme.primary,
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color:
                        //             Colors.black.withOpacity(0.2), // Shadow color
                        //         offset:
                        //             const Offset(0, 4), // Shadow offset (x, y)
                        //         blurRadius: 8, // Shadow blur radius
                        //         spreadRadius: 2, // Shadow spread radius
                        //       ),
                        //     ],
                        //   ),

                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Container(
                        //         width: MediaQuery.of(context).size.width * 0.45,
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 8, vertical: 12),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(12),
                        //           color: Theme.of(context).colorScheme.primary,
                        //         ),
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             Text(
                        //               'الحضـــــور',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .bodyLarge!
                        //                   .copyWith(
                        //                     color: Colors.white,
                        //                   ),
                        //             ),
                        //             const Gap(12),
                        //             Text(
                        //               '${state.attendances}',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .bodyLarge!
                        //                   .copyWith(
                        //                     color: Colors.white,
                        //                   ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       // Gap(52),
                        //       Container(
                        //         width: MediaQuery.of(context).size.width * 0.45,
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal: 8, vertical: 12),
                        //         decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(12),
                        //           color: Theme.of(context).colorScheme.primary,
                        //         ),
                        //         child: Column(
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           crossAxisAlignment: CrossAxisAlignment.center,
                        //           children: [
                        //             Text(
                        //               'العدد الكلي',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .bodyLarge!
                        //                   .copyWith(
                        //                     color: Colors.white,
                        //                   ),
                        //             ),
                        //             const Gap(12),
                        //             Text(
                        //               '${state.totalStudents}',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .bodyLarge!
                        //                   .copyWith(
                        //                     color: Colors.white,
                        //                   ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),

                        // ),
                        // const Gap(24),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Container(
                        //       width: MediaQuery.of(context).size.width * 0.45,
                        //       padding: const EdgeInsets.symmetric(
                        //           horizontal: 8, vertical: 12),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(12),
                        //         color: Theme.of(context).colorScheme.surface,
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.black
                        //                 .withOpacity(0.15), // Shadow color
                        //             offset: const Offset(
                        //                 0, 1), // Shadow offset (x, y)
                        //             blurRadius: 8, // Shadow blur radius
                        //             spreadRadius: 2, // Shadow spread radius
                        //           ),
                        //         ],
                        //       ),
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             '${state.thomon}',
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .bodyLarge!
                        //                 .copyWith(
                        //                   color: Colors.black,
                        //                   fontSize: 25,
                        //                 ),
                        //           ),
                        //           Gap(12),
                        //           Text(
                        //             'ثمن',
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .bodySmall!
                        //                 .copyWith(
                        //                   color: Colors.black,
                        //                 ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     // Gap(52),
                        //     Container(
                        //       width: MediaQuery.of(context).size.width * 0.45,
                        //       padding: const EdgeInsets.symmetric(
                        //           horizontal: 8, vertical: 12),
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(12),
                        //         color: Theme.of(context).colorScheme.surface,
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.black
                        //                 .withOpacity(0.15), // Shadow color
                        //             offset: const Offset(
                        //                 0, 1), // Shadow offset (x, y)
                        //             blurRadius: 8, // Shadow blur radius
                        //             spreadRadius: 2, // Shadow spread radius
                        //           ),
                        //         ],
                        //       ),
                        //       child: Column(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         crossAxisAlignment: CrossAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             '${state.helga}',
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .bodyLarge!
                        //                 .copyWith(
                        //                   color: Colors.black,
                        //                   fontSize: 25,
                        //                 ),
                        //           ),
                        //           Gap(12),
                        //           Text(
                        //             'حلقة',
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .bodySmall!
                        //                 .copyWith(
                        //                   color: Colors.black,
                        //                 ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        const Gap(24),
                        for (var type in state.totalByTypeList!.keys)
                          Column(
                            children: [
                              const Gap(12),
                              Container(
                                height: 60,
                                //  width: MediaQuery.of(context).size.width * 0.45,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Theme.of(context).colorScheme.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(0.15), // Shadow color
                                      offset: const Offset(
                                          0, 1), // Shadow offset (x, y)
                                      blurRadius: 8, // Shadow blur radius
                                      spreadRadius: 2, // Shadow spread radius
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${state.totalByTypeList![type]!.passed} \\ ${state.totalByTypeList![type]!.total}',
                                      textDirection: TextDirection.rtl,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.black,
                                          ),
                                    ),
                                    Gap(12),
                                    Text(
                                      type,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: Colors.black,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                        const Gap(24),
                        Container(
                          child: TextButton(
                            onPressed: () {
                              context
                                  .read<ViewDailyRecordsBloc>()
                                  .add(LoadRecordsEvent(DateTime.now()));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: context.read<ReportBloc>(),
                                    child: ViewDailyRecords(),
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              "عرض تقرير اليوم",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontSize,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            if (state is CreateNewMonthState) {
              // Use addPostFrameCallback to show dialog after build
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateNewMonthPage(),
                  ),
                );
              });
              return const SizedBox.shrink();
            }
            if (state is DashboardErrorState) {
              return Center(
                child: Text(state.error),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
