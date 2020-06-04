import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_design/widgets/circular_list_view.dart';
import 'important_data.dart';
class TagStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      overflow: Overflow.clip,
      children: <Widget>[
        Consumer<ImportantData>(
          builder: (context, data, _) {
            final values = data.tags.values;
            return PieChart(
              PieChartData(
                sectionsSpace: 1,
                centerSpaceRadius: 140,
                borderData: FlBorderData(
                  show: false,
                ),
                sections: List.generate(
                  data.tags.length,
                  (index) => PieChartSectionData(
                    value: values.elementAt(index).reps.toDouble() < 30
                        ? 40
                        : values.elementAt(index).reps.toDouble(),
                    titleStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    title: values.elementAt(index).reps.toString(),
                    color: values.elementAt(index).color,
                  ),
                ),
              ),
            );
          },
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Material(
              elevation: 10,
              shape: CircleBorder(),
              child: CircleAvatar(
                child: CircularListView(),
                radius: 140,
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}