import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:takyeem/features/reports/entities/student_daily_report_entity.dart';
import 'package:takyeem/features/reports/widgets/snackbar_message.dart';

import '../blocs/report_bloc/report_bloc.dart';

class AddDailyRecords extends StatelessWidget {
  const AddDailyRecords({super.key});

  List<DropdownMenuItem<String>> getDropdownItems(
      List<dynamic> items, BuildContext context) {
    List<DropdownMenuItem<String>> dropdownItems = items.map((status) {
      return DropdownMenuItem<String>(
        value: status.id.toString(), // Assuming `id` is a unique identifier
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
          BlocBuilder<ReportBloc, ReportState>(
            builder: (context, state) {
              if (state is ReportInitial) {
                context.read<ReportBloc>().add(LoadMainDataEvent());
              }
              if (state is ReportLoadingState) {
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
              } else if (state is ReportLoadedState) {
                StudentDailyReportEntity reportEntity =
                    StudentDailyReportEntity();

                return state.studentswithOutRecords == null ||
                        state.studentswithOutRecords!.isEmpty
                    ? SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(
                          child: Text(
                            "لا يوجد طلبة",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      )
                    : Expanded(
                        child: FormBuilder(
                          key: _formKey,
                          child: ListView.builder(
                            itemCount: state.studentswithOutRecords!.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                                height: 90,
                                child: Row(
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
                                              reportEntity.type == null) {
                                            showTimedMessage(context,
                                                "أكمل البيانات الخاصة بالتسميع لـ \n\"${state.studentswithOutRecords![index].firstName} ${state.studentswithOutRecords![index].lastName}\"");
                                            return;
                                          }

                                          reportEntity.studentId = state
                                              .studentswithOutRecords![index]
                                              .id;
                                          reportEntity.date = DateTime.now();
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
                                                ), // Replace with your note content
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
                                                                .pop(); // Close the dialog
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
                                      width:
                                          65, // Increased width to accommodate icon
                                      child: DropdownButtonFormField(
                                        isExpanded:
                                            true, // Added to control dropdown width
                                        isDense:
                                            true, // Added to reduce overall height
                                        elevation: 0,
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 8,
                                              horizontal:
                                                  4), // Added horizontal padding
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
                                          reportEntity.type = state
                                                  .dailyRecordType[
                                                      int.parse(value) - 1]
                                                  .name ??
                                              "";
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 60,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              "${state.studentswithOutRecords![index].firstName} "),
                                          Text(state
                                              .studentswithOutRecords![index]
                                              .lastName),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      );
              } else if (state is ReportErrorState) {}
              return const Text("No students");
            },
          ),
        ],
      ),
    );
  }
}
