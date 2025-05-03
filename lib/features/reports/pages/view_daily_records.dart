import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:takyeem/features/reports/blocs/report_bloc/report_bloc.dart';

class ViewDailyRecords extends StatelessWidget {
  const ViewDailyRecords({super.key});

  Future<void> _selectDate(BuildContext context, DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      locale: const Locale('ar'),
    );
    if (picked != null && picked != initialDate) {
      context.read<ReportBloc>().add(LoadRecordsByDateEvent(date: picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            DateTime displayedDate = DateTime.now();
            String titleText = "التقرير اليومي";

            if (state is RecordsLoadedState) {
              displayedDate = state.selectedDate;
              final now = DateTime.now();
              if (displayedDate.year != now.year ||
                  displayedDate.month != now.month ||
                  displayedDate.day != now.day) {
                titleText =
                    "تقرير يوم: ${DateFormat('d/M/yyyy', 'ar').format(displayedDate)}";
              }
            } else if (state is NotStudyDayState) {
              // Optionally display date from NotStudyDayState if needed
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  titleText,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: Icon(
                    Icons.calendar_today,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => _selectDate(context, displayedDate),
                ),
              ],
            );
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is ReportInitial) {
              context.read<ReportBloc>().add(LoadTodayRecordsEvent());
              return Center(
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotatePulse,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  strokeWidth: 2,
                  backgroundColor: Colors.transparent,
                  pathBackgroundColor: Colors.transparent,
                ),
              );
            }
            if (state is ReportLoadingState) {
              return Center(
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotatePulse,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                  strokeWidth: 2,
                  backgroundColor: Colors.transparent,
                  pathBackgroundColor: Colors.transparent,
                ),
              );
            }
            if (state is NotStudyDayState) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),
                      const Gap(10),
                      ElevatedButton(
                        onPressed: () => context
                            .read<ReportBloc>()
                            .add(LoadTodayRecordsEvent()),
                        child: const Text("عرض تقرير اليوم"),
                      )
                    ],
                  ),
                ),
              );
            }
            if (state is RecordsLoadedState) {
              return state.studentsRecords == null ||
                      state.studentsRecords!.isEmpty
                  ? Center(
                      child: Text(
                        "لا يوجد سجلات لهذا اليوم",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  offset: const Offset(0, 4),
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            height: 50,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.16,
                                  child: Text(
                                    "ملحوظة",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                  child: Text(
                                    "الشيخ",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                  child: Text(
                                    "النتيجة",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                  child: Text(
                                    "نوع \n التسميع",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.17,
                                  child: Text(
                                    "الاسم",
                                    textAlign: TextAlign.right,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.75,
                            child: ListView.builder(
                              itemCount: state.studentsRecords!.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        offset: const Offset(0, 4),
                                        blurRadius: 2,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  height: 65,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.16,
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: state
                                                  .studentsRecords![index]
                                                  .note
                                                  .isEmpty
                                              ? null
                                              : () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        titlePadding:
                                                            const EdgeInsets
                                                                .all(16),
                                                        buttonPadding:
                                                            EdgeInsets.zero,
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        iconPadding:
                                                            EdgeInsets.zero,
                                                        insetPadding:
                                                            EdgeInsets.zero,
                                                        actionsPadding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 16,
                                                                top: 5,
                                                                bottom: 5),
                                                        title: Align(
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: Text(
                                                            "ملحوظة",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ),
                                                        content: Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 16),
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 10),
                                                          height: 260,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                state
                                                                    .studentsRecords![
                                                                        index]
                                                                    .note,
                                                                maxLines: 8,
                                                                // textDirection: TextDirection.rtl,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                          icon: Icon(
                                            Icons.note_add,
                                            color: state.studentsRecords![index]
                                                    .note.isEmpty
                                                ? Theme.of(context)
                                                    .disabledColor
                                                : Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.16,
                                        child: Text(
                                          state.studentsRecords![index].sheikh,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.18,
                                        child: Text(
                                          state.studentsRecords![index].status,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.16,
                                        child: Text(
                                          state.studentsRecords![index].type,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.21,
                                        child: Text(
                                          "${state.studentsRecords![index].student?.firstName}  ${state.studentsRecords![index].student?.lastName}",
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
            } else if (state is ReportErrorState) {
              return Center(child: Text(state.error));
            }
            return const Center(child: Text("يرجى تحديد تاريخ لعرض التقرير"));
          },
        ),
      ),
    );
  }
}
