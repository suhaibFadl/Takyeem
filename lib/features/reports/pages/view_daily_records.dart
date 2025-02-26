import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:takyeem/features/reports/blocs/report_bloc/report_bloc.dart';

class ViewDailyRecords extends StatelessWidget {
  const ViewDailyRecords({super.key});

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   context.read<ReportBloc>().add((LoadMainDataEvent()));
    // });
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocBuilder<ReportBloc, ReportState>(
          builder: (context, state) {
            if (state is ReportInitial) {
              context.read<ReportBloc>().add(LoadTodayRecordsEvent());
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
            } else if (state is TodayRecordsState) {
              return state.studentsRecords!.isEmpty
                  ? Center(
                      child: Text(
                        "لا يوجد طلبة",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(10),
                            // border: Border.all(
                            //   color: Theme.of(context).colorSceme.primary,
                            // ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.05), // Shadow color
                                offset:
                                    const Offset(0, 4), // Shadow offset (x, y)
                                blurRadius: 2, // Shadow blur radius
                                spreadRadius: 1, // Shadow spread radius
                              ),
                            ],
                          ),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.18,
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
                                width: MediaQuery.of(context).size.width * 0.18,
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
                                width: MediaQuery.of(context).size.width * 0.18,
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
                                width: MediaQuery.of(context).size.width * 0.18,
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
                                width: MediaQuery.of(context).size.width * 0.18,
                                child: Text(
                                  "الاسم",
                                  textAlign: TextAlign.center,
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
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: ListView.builder(
                            itemCount: state.studentsRecords!.length,
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
                                height: 65,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.18,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: state.studentsRecords![index]
                                                .note.isEmpty
                                            ? null
                                            : () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      titlePadding:
                                                          const EdgeInsets.all(
                                                              16),
                                                      buttonPadding:
                                                          EdgeInsets.zero,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      iconPadding:
                                                          EdgeInsets.zero,
                                                      insetPadding:
                                                          EdgeInsets.zero,
                                                      actionsPadding:
                                                          const EdgeInsets.only(
                                                              left: 16,
                                                              top: 5,
                                                              bottom: 5),
                                                      title: Align(
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: Text(
                                                          "ملحوظة",
                                                          style:
                                                              Theme.of(context)
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
                                                        margin: const EdgeInsets
                                                            .only(top: 10),
                                                        // decoration:
                                                        //     BoxDecoration(
                                                        //   border: Border(
                                                        //     top: BorderSide(
                                                        //       color: Theme.of(
                                                        //               context)
                                                        //           .colorScheme
                                                        //           .primary,
                                                        //       width: 1,
                                                        //     ),
                                                        //     bottom: BorderSide(
                                                        //       color: Theme.of(
                                                        //               context)
                                                        //           .colorScheme
                                                        //           .primary,
                                                        //       width: 1,
                                                        //     ),
                                                        //   ),
                                                        // ),
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
                                                              textDirection:
                                                                  TextDirection
                                                                      .rtl,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodySmall,
                                                            ),
                                                          ],
                                                        ),
                                                      ), // Replace with your note content
                                                      actions: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
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
                                                                  "إغلاق",
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
                                        icon: Icon(
                                          Icons.note_add,
                                          color: state.studentsRecords![index]
                                                  .note.isEmpty
                                              ? Theme.of(context).disabledColor
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.18,
                                      child: Text(
                                        state.studentsRecords![index].sheikh,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.18,
                                      child: Text(
                                        state.studentsRecords![index].status,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.18,
                                      child: Text(
                                        state.studentsRecords![index].type,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.18,
                                      child: Text(
                                        "${state.studentsRecords![index].student?.firstName} ${state.studentsRecords![index].student?.lastName}",
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
            } else if (state is ReportErrorState) {}
            return const Text("لا يوجد طلبة");
          },
        ),
      ),
    );
  }
}
