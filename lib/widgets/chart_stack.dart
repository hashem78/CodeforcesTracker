import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_design/widgets/circular_list_view.dart';

class ChartStack extends StatelessWidget {
  //this should come from a list.generate
  final List<PieChartSectionData> sections;
  final CircularListView circularListView;
  ChartStack({required this.sections, required this.circularListView});
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.hardEdge, fit: StackFit.expand,
      children: <Widget>[
        PieChart(
          PieChartData(
            sectionsSpace: 1,
            centerSpaceRadius: 140,
            borderData: FlBorderData(
              show: false,
            ),
            sections: sections,
            
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Material(
              elevation: 10,
              shape: CircleBorder(),
              child: CircleAvatar(
                child: circularListView,
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
