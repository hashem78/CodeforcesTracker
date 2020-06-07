import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_design/widgets/circular_list_view.dart';
import 'package:my_design/data/centralized_data.dart';
import 'package:provider/provider.dart';

class TagStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, _) => Stack(
        fit: StackFit.expand,
        overflow: Overflow.clip,
        children: <Widget>[
          PieChart(
            PieChartData(
              sectionsSpace: 1,
              centerSpaceRadius: 140,
              borderData: FlBorderData(
                show: false,
              ),
              sections: List.generate(
                data.tags.length,
                (index) => PieChartSectionData(
                  value: data.tags.values.elementAt(index).reps.toDouble() < 100
                      ? 100
                      : data.tags.values.elementAt(index).reps.toDouble(),
                  titleStyle: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  title: data.tags.values.elementAt(index).reps.toString(),
                  color: data.tags.values.elementAt(index).color,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Material(
                elevation: 10,
                shape: CircleBorder(),
                child: CircleAvatar(
                  child: CircularListView(
                    itemCount: data.tags.length,
                    itemBuilder: (context, index) {
                      return Container(
                        alignment: Alignment.center,
                        child: Text(
                          data.tags.keys.elementAt(index),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        width: 300,
                        color: data.tags.values.elementAt(index).color,
                      );
                    },
                  ),
                  radius: 140,
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
