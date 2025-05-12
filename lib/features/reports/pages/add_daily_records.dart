import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:takyeem/features/reports/entities/student_daily_report_entity.dart';
import 'package:takyeem/features/reports/widgets/snackbar_message.dart';
import 'package:takyeem/features/students/models/student.dart';

import '../blocs/report_bloc/report_bloc.dart';

class AddDailyRecords extends StatelessWidget {
  AddDailyRecords({super.key});

  final TextEditingController _searchController = TextEditingController();

  List<DropdownMenuItem<String>> getDropdownItems(
      List<dynamic> items, BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = items.map((status) {
      return DropdownMenuItem<String>(
        value: status.id.toString(),
        child: Text(
          status.name, // Replace `name` with the property to display
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
    }).toList();
    return dropdownItems;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormBuilderState>();

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 1, // Removes elevation when scrolling
        backgroundColor: Theme.of(context).colorScheme.surface,

        // shadowColor: Colors.transparent,
        // centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "التقرير اليومي",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: _searchController,
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(
                  hintStyle: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[600]),
                  hintText: "البحث عن طالب...",
                  hintTextDirection: TextDirection.rtl,
                  prefixIcon: Icon(Icons.search, color: Colors.grey[700]),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[700]),
                    onPressed: () {
                      _searchController.clear();
                      context.read<ReportBloc>().add(SearchStudentsEvent(""));
                    },
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  filled: false,
                  // contentPadding:
                  //     const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                ),
                onChanged: (query) {
                  context.read<ReportBloc>().add(SearchStudentsEvent(query));
                },
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<ReportBloc, ReportState>(
              listener: (context, state) {
                if (state is ReportErrorState) {
                  showTimedMessage(context, "خطأ: ${state.error}");
                }
              },
              builder: (context, state) {
                if (state is ReportInitial) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.read<ReportBloc>().state is ReportInitial) {
                      context.read<ReportBloc>().add(LoadMainDataEvent());
                    }
                  });
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ReportLoadingState &&
                    state is! ReportLoadedState) {
                  return Center(
                      child: SizedBox(
                          width: 50,
                          height: 50,
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballClipRotatePulse,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                            strokeWidth: 2,
                            backgroundColor: Colors.transparent,
                            pathBackgroundColor: Colors.transparent,
                          )));
                }
                if (state is NotStudyDayState) {
                  return Center(child: Text(state.message));
                }

                if (state is ReportLoadedState) {
                  if (state.allStudentsWithoutRecords == null ||
                      state.allStudentsWithoutRecords!.isEmpty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: Center(
                        child: Text(
                          "لا يوجد طلبة",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    );
                  }

                  final displayStudents = state.filteredStudents;

                  if (displayStudents.isEmpty &&
                      state.currentSearchQuery.isNotEmpty) {
                    return Center(
                        child: Text(
                      "لا يوجد طالب بهذا الاسم: '${state.currentSearchQuery}'",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ));
                  }

                  return Expanded(
                      child: RefreshIndicator(
                    onRefresh: () async =>
                        context.read<ReportBloc>().add(LoadMainDataEvent()),
                    child: FormBuilder(
                      key: _formKey,
                      child: ListView.builder(
                        itemCount: displayStudents.length,
                        itemBuilder: (context, index) {
                          final student = displayStudents[index];
                          StudentDailyReportEntity reportEntity =
                              StudentDailyReportEntity();

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
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
                            height: 110,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 20),
                                      width: 100,
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        isDense: true,
                                        elevation: 0,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 4),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                        itemHeight: 50,
                                        iconSize: 24,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(

                                                // height: 1.2,
                                                ),
                                        hint: Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Text(
                                            "${student.surah?.name}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        items: getDropdownItems(
                                                state.surahs, context)
                                            .map((item) {
                                          return DropdownMenuItem(
                                            value: item.value,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: Text(
                                                (item.child as Text).data ?? '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      height: 1.2,
                                                    ),
                                                textDirection:
                                                    TextDirection.rtl,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value == null) return;
                                          reportEntity.surahId = state
                                              .surahs[int.parse(value) - 1].id;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Text(
                                        "${student.firstName} ${student.fatherName} ${student.lastName}",
                                        textAlign: TextAlign.end,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 23,
                                      height: 23,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          if (reportEntity.sheikh == null ||
                                              reportEntity.status == null ||
                                              reportEntity.typeId == null) {
                                            showTimedMessage(context,
                                                "أكمل البيانات الخاصة بالتسميع لـ \n\"${student.firstName} ${student.lastName}\"");
                                            return;
                                          }

                                          reportEntity.surahId ??=
                                              student.surah?.id;

                                          if (reportEntity.surahId! >
                                              student.surah!.id) {
                                            showTimedMessage(context,
                                                " السورة المختارة أصغر من السورة الحالية للطالب ${student.firstName} ${student.fatherName} ${student.lastName}");
                                            return;
                                          }
                                          if (reportEntity.type == "ثمن") {
                                            reportEntity.surahId =
                                                reportEntity.surahId ??
                                                    student.surah?.id;
                                          }

                                          reportEntity.studentId = student.id;
                                          reportEntity.date = DateTime.now();
                                          debugPrint(
                                              "reportEntity: ${reportEntity}");
                                          context.read<ReportBloc>().add(
                                              AddDailyRecordEvent(reportEntity
                                                  .toDailyRecord()));
                                        },
                                        icon: Icon(Icons.arrow_circle_left,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 23,
                                      height: 23,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                titlePadding:
                                                    const EdgeInsets.all(16),
                                                buttonPadding: EdgeInsets.zero,
                                                contentPadding: EdgeInsets.zero,
                                                iconPadding: EdgeInsets.zero,
                                                insetPadding: EdgeInsets.zero,
                                                actionsPadding:
                                                    const EdgeInsets.only(
                                                        left: 16,
                                                        top: 5,
                                                        bottom: 5),
                                                title: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                    "إضافة ملحوظة",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                ),
                                                content: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16),
                                                  margin: const EdgeInsets.only(
                                                      top: 10),
                                                  decoration: BoxDecoration(
                                                    border: Border(
                                                      top: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        width: 1,
                                                      ),
                                                      bottom: BorderSide(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        width: 1,
                                                      ),
                                                    ),
                                                  ),
                                                  height: 260,
                                                  child: Column(
                                                    children: [
                                                      TextFormField(
                                                        controller:
                                                            reportEntity.note,
                                                        minLines: 1,
                                                        maxLines: 8,
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        decoration:
                                                            InputDecoration(
                                                          hintText:
                                                              "الملحوظة...",
                                                          hintTextDirection:
                                                              TextDirection.rtl,
                                                          hintStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                          border:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 70,
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                            "تم",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.note_add,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 65,
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        isDense: true,
                                        elevation: 0,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 4),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                        itemHeight: 55,
                                        iconSize: 24,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              height: 1.2,
                                            ),
                                        hint: Container(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Text(
                                            "الشيخ",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                            textDirection: TextDirection.rtl,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        items: getDropdownItems(
                                                state.sheikhs, context)
                                            .map((item) {
                                          return DropdownMenuItem(
                                            value: item.value,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: Text(
                                                (item.child as Text).data ?? '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      height: 1.2,
                                                    ),
                                                textDirection:
                                                    TextDirection.rtl,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value == null) return;
                                          reportEntity.sheikh = state
                                              .sheikhs[int.parse(value) - 1]
                                              .name;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        isDense: true,
                                        elevation: 0,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                        itemHeight: 55,
                                        iconSize: 24,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              height: 1.2,
                                            ),
                                        hint: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Text(
                                              "نتيجة\nالتسميع",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    height: 1.2,
                                                  ),
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            )),
                                        items: getDropdownItems(
                                                state.dailyRecordStatus,
                                                context)
                                            .map((item) {
                                          return DropdownMenuItem(
                                            value: item.value,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: Text(
                                                (item.child as Text).data ?? '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      height: 1.2,
                                                    ),
                                                textDirection:
                                                    TextDirection.rtl,
                                                textAlign: TextAlign.center,
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value == null) return;
                                          reportEntity.status = state
                                                  .dailyRecordStatus[
                                                      int.parse(value) - 1]
                                                  .name ??
                                              "";
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: DropdownButtonFormField(
                                        isExpanded: true,
                                        isDense: true,
                                        elevation: 0,
                                        decoration: const InputDecoration(
                                          contentPadding:
                                              EdgeInsets.symmetric(vertical: 8),
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                        ),
                                        itemHeight: 55,
                                        iconSize: 24,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              height: 1.2,
                                            ),
                                        hint: Container(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Text(
                                              "نـــــوع\nالتسميع",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    height: 1.2,
                                                  ),
                                              textDirection: TextDirection.rtl,
                                              textAlign: TextAlign.center,
                                              softWrap: true,
                                              overflow: TextOverflow.visible,
                                            )),
                                        items: getDropdownItems(
                                                state.dailyRecordType, context)
                                            .map((item) {
                                          return DropdownMenuItem(
                                            value: item.value,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: Text(
                                                (item.child as Text).data ?? '',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      height: 1.2,
                                                    ),
                                                textDirection:
                                                    TextDirection.rtl,
                                                textAlign: TextAlign.center,
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value == null) return;
                                          debugPrint("value: $value");
                                          var type = state.dailyRecordType
                                              .firstWhere((element) =>
                                                  element.id ==
                                                  double.parse(value));
                                          reportEntity.typeId = type.id;
                                          reportEntity.type = type.name;

                                          debugPrint(
                                              "reportEntity.type: ${reportEntity.type}");
                                          debugPrint(
                                              "reportEntity.typeId: ${reportEntity.typeId}");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ));
                }

                return const Text("No students");
              },
            ),
          ),
        ],
      ),
    );
  }
}
