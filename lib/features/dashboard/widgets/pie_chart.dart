import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:takyeem/features/dashboard/widgets/indicator.dart';

class PieChartSample2 extends StatefulWidget {
  const PieChartSample2({
    super.key,
    required this.primaryTitle,
    required this.secondaryTitle,
    required this.primaryValue,
    required this.secondaryValue,
  });

  final String primaryTitle;
  final String secondaryTitle;
  final double primaryValue;
  final double secondaryValue;

  @override
  State<StatefulWidget> createState() => PieChart2State();
}

class PieChart2State extends State<PieChartSample2> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .75,
      child: Row(
        children: <Widget>[
          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 10,
                  centerSpaceRadius: 40,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: <Widget>[
          //     Indicator(
          //       color: Theme.of(context).colorScheme.primary,
          //       text: 'الحضور',
          //       isSquare: true,
          //     ),
          //     SizedBox(
          //       height: 4,
          //     ),
          //     Indicator(
          //       color: Theme.of(context).colorScheme.secondary,
          //       text: 'الغياب',
          //       isSquare: true,
          //     ),
          //     SizedBox(
          //       height: 4,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 14.0 : 12.0;
      final radius = isTouched ? 40.0 : 30.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: widget.primaryValue,
            title: '${widget.primaryValue}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            titlePositionPercentageOffset: .40,
            color: Colors.red,
            value: widget.secondaryValue,
            title: '${widget.secondaryValue}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            // titlePositionPercentageOffset: .40,
            color: const Color.fromARGB(154, 158, 158, 158),
            value: 100 - (widget.primaryValue + widget.secondaryValue),
            title: '',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
