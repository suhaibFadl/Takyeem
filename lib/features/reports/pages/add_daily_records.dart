import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:takyeem/features/reports/blocs/bloc/report_bloc.dart';
import 'package:takyeem/features/reports/entities/student_daily_report_entity.dart';
import 'package:takyeem/features/reports/widgets/snackbar_message.dart';

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
    return Scaffold(
      appBar: AppBar(
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

                return state.studentswithOutRecords == null
                    ? const Text("لا يوجد طلبة")
                    : Expanded(
                        child: ListView.builder(
                          itemCount: state.studentswithOutRecords!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
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
                                  IconButton(
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
                                          .studentswithOutRecords![index].id;
                                      reportEntity.date = DateTime.now();
                                      context.read<ReportBloc>().add(
                                          AddDailyRecordEvent(
                                              reportEntity.toDailyRecord()));
                                    },
                                    icon: Icon(Icons.arrow_circle_left,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary),
                                  ),
                                  IconButton(
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
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "إضافة ملحوظة",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ),
                                            content: Container(
                                              padding: const EdgeInsets.only(
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
                                                  TextField(
                                                    controller:
                                                        reportEntity.note,
                                                    minLines: 1,
                                                    maxLines: 8,
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    decoration: InputDecoration(
                                                      hintText: "الملحوظة...",
                                                      hintTextDirection:
                                                          TextDirection.rtl,
                                                      hintStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodySmall,
                                                      border: InputBorder.none,
                                                      enabledBorder: InputBorder
                                                          .none, // Remove border when enabled
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
                                                        Navigator.of(context)
                                                            .pop(); // Close the dialog
                                                      },
                                                      child: Text(
                                                        "إغلاق",
                                                        style: Theme.of(context)
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
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 60,
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: DropdownButton(
                                        // alignment: Alignment.center,
                                        // isDense: true,
                                        elevation: 0,
                                        underline: const SizedBox(),
                                        itemHeight: 65,
                                        // menuWidth: 20,
                                        // elevation: 0,
                                        // padding: EdgeInsets.all(20),
                                        iconSize: 45,
                                        hint: Text(
                                          "الشيخ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(fontSize: 25),
                                          textDirection: TextDirection.rtl,
                                          // textAlign: TextAlign.start,
                                        ),
                                        items: getDropdownItems(
                                            state.sheikhs, context),
                                        onChanged: (value) {
                                          if (value == null) return;
                                          reportEntity.sheikh = state
                                              .sheikhs[int.parse(value) - 1]
                                              .name;
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: DropdownButton(
                                        elevation: 0,
                                        underline: const SizedBox(),
                                        itemHeight: 65,
                                        // elevation: 0,
                                        // padding: EdgeInsets.all(20),
                                        iconSize: 45,
                                        hint: Text(
                                          "نتيجة \nالتسميع",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(fontSize: 25),
                                          textDirection: TextDirection.rtl,
                                          // textAlign: TextAlign.start,
                                        ),
                                        items: getDropdownItems(
                                            state.dailyRecordStatus, context),

                                        onChanged: (value) {
                                          reportEntity.status = state
                                                  .dailyRecordStatus[
                                                      int.parse(value!) - 1]
                                                  .name ??
                                              "";
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: DropdownButton(
                                        // dropdownColor: Theme.of(context).colorScheme.secondary,
                                        elevation: 0,
                                        itemHeight: 65,
                                        underline: const SizedBox(),
                                        iconSize: 45,
                                        // borderRadius: BorderRadius.circular(10),
                                        hint: Text(
                                          "نـــــوع  \nالتسميع",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(fontSize: 25),
                                          textDirection: TextDirection.rtl,
                                          // textAlign: TextAlign.start,
                                        ),
                                        items: getDropdownItems(
                                            state.dailyRecordType, context),
                                        onChanged: (value) {
                                          reportEntity.type = state
                                                  .dailyRecordType[
                                                      int.parse(value!) - 1]
                                                  .name ??
                                              "";
                                        },
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          "${state.studentswithOutRecords![index].firstName} "),
                                      Text(state.studentswithOutRecords![index]
                                          .lastName),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
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
