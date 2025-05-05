import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:takyeem/features/reports/blocs/view_daily_records_bloc/view_daily_records_bloc.dart';
import 'dart:ui' as ui;

class ViewDailyRecords extends StatelessWidget {
  ViewDailyRecords({super.key});

  final TextEditingController _searchController = TextEditingController();

  Future<void> _selectDate(BuildContext context, DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      locale: const Locale('ar'),
    );
    if (picked != null && picked != initialDate) {
      _searchController.clear();
      context.read<ViewDailyRecordsBloc>().add(LoadRecordsEvent(picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: BlocBuilder<ViewDailyRecordsBloc, ViewDailyRecordsState>(
          builder: (context, state) {
            DateTime displayedDate = DateTime.now();
            String titleText = "التقرير اليومي";
            debugPrint("state: $state");
            if (state is ViewDailyRecordsLoadedState) {
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  controller: _searchController,
                  textDirection: ui.TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: "البحث عن طالب...",
                    hintTextDirection: ui.TextDirection.rtl,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        context
                            .read<ViewDailyRecordsBloc>()
                            .add(SearchDailyRecordsEvent(""));
                      },
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                  ),
                  onChanged: (query) {
                    context
                        .read<ViewDailyRecordsBloc>()
                        .add(SearchDailyRecordsEvent(query));
                  },
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ViewDailyRecordsBloc, ViewDailyRecordsState>(
                builder: (context, state) {
                  if (state is ViewDailyRecordsInitial) {
                    context
                        .read<ViewDailyRecordsBloc>()
                        .add(LoadRecordsEvent(DateTime.now()));
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
                  if (state is ViewDailyRecordsLoadingState) {
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
                                  .read<ViewDailyRecordsBloc>()
                                  .add(LoadRecordsEvent(DateTime.now())),
                              child: const Text("عرض تقرير اليوم"),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is ViewDailyRecordsLoadedState) {
                    if (state.allStudentsRecords == null ||
                        state.allStudentsRecords!.isEmpty) {
                      return Center(
                        child: Text(
                          "لا يوجد سجلات لهذا اليوم",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      );
                    }

                    final displayRecords = state.filteredStudentsRecords;

                    if (displayRecords.isEmpty &&
                        state.currentSearchQuery.isNotEmpty) {
                      return Center(
                          child: Text(
                        "لا يوجد طالب مسجل بهذا الاسم: '${state.currentSearchQuery}'",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ));
                    }

                    return RefreshIndicator(
                      onRefresh: () async {
                        _searchController.clear();
                        context
                            .read<ViewDailyRecordsBloc>()
                            .add(LoadRecordsEvent(state.selectedDate));
                      },
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
                          Expanded(
                            child: ListView.builder(
                              itemCount: displayRecords.length,
                              itemBuilder: (context, index) {
                                final record = displayRecords[index];
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
                                          onPressed: record.note.isEmpty
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
                                                                record.note,
                                                                maxLines: 8,
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
                                            color: record.note.isEmpty
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
                                          record.sheikh,
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
                                          record.status,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.16,
                                        child: Text(
                                          record.type,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.21,
                                        child: Text(
                                          record.student != null
                                              ? "${record.student!.firstName}  ${record.student!.lastName}"
                                              : "غير معروف",
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
                  } else if (state is ViewDailyRecordsErrorState) {
                    return Center(child: Text(state.message));
                  }
                  return const Center(
                      child: Text("يرجى تحديد تاريخ لعرض التقرير"));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
