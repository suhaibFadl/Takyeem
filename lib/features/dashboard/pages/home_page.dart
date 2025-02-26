import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:takyeem/features/auth/auth_service.dart';
import 'package:takyeem/features/dashboard/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:takyeem/features/dashboard/pages/create_new_month.dart';
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
                  child: ListView(
                    children: [
                      const Gap(12),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.primary,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              offset:
                                  const Offset(0, 4), // Shadow offset (x, y)
                              blurRadius: 8, // Shadow blur radius
                              spreadRadius: 2, // Shadow spread radius
                            ),
                          ],
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            textDirection: TextDirection.rtl,
                            '${state.today.week_day}, ${state.today.day} ${state.today.month_name}  ${state.today.year} هـ',
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ),
                      const Gap(12),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Theme.of(context).colorScheme.primary,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.black.withOpacity(0.2), // Shadow color
                              offset:
                                  const Offset(0, 4), // Shadow offset (x, y)
                              blurRadius: 8, // Shadow blur radius
                              spreadRadius: 2, // Shadow spread radius
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'الحضـــــور',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                  const Gap(12),
                                  Text(
                                    '${state.attendances}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            // Gap(52),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'العدد الكلي',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                  const Gap(12),
                                  Text(
                                    '${state.totalStudents}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Theme.of(context).colorScheme.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.2), // Shadow color
                                  offset: const Offset(
                                      0, 4), // Shadow offset (x, y)
                                  blurRadius: 8, // Shadow blur radius
                                  spreadRadius: 2, // Shadow spread radius
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'ثمن',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                const Gap(12),
                                Text(
                                  '${state.thomon}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          // Gap(52),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Theme.of(context).colorScheme.primary,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.2), // Shadow color
                                  offset: const Offset(
                                      0, 4), // Shadow offset (x, y)
                                  blurRadius: 8, // Shadow blur radius
                                  spreadRadius: 2, // Shadow spread radius
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'حلقة',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                const Gap(12),
                                Text(
                                  '${state.helga}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: Colors.white,
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
                                .read<ReportBloc>()
                                .add(LoadTodayRecordsEvent());
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
              );
            }
            // if (state is CreateNewMonthState) {
            //   return CreateNewMonthPage();
            // }
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
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
