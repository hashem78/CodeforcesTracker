import 'package:flutter/material.dart';
import '../widgets/dark_beveled_card.dart';
import 'package:my_design/widgets/chart_stack.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:my_design/widgets/circular_list_view.dart';

class ChartedScreen extends StatelessWidget {
  final dynamic data;
  final dynamic top10data;

  ChartedScreen({@required this.data, @required this.top10data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            child: ChartStack(
              sections: List.generate(
                data.length,
                (index) => PieChartSectionData(
                  value: data.values.elementAt(index).reps.toDouble() < 100
                      ? 100
                      : data.values.elementAt(index).reps.toDouble(),
                  titleStyle: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  title: data.values.elementAt(index).reps.toString(),
                  color: data.values.elementAt(index).color,
                ),
              ),
              circularListView: CircularListView(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Container(
                    alignment: Alignment.center,
                    child: Text(
                      data.keys.elementAt(index),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    width: 300,
                    color: data.values.elementAt(index).color,
                  );
                },
              ),
            ),
            color: Colors.black,
          ),
        ),
        Expanded(
          child: Scrollbar(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: top10data.length,
              itemBuilder: (context, index) {
                return DarkBeveledCard(
                  title: top10data.keys.toList().elementAt(index),
                  subtitle: top10data.values is Iterable<String>
                      ? top10data.values.elementAt(index)
                      : top10data.values.elementAt(index).join(
                          ", "),
                  index: index,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
