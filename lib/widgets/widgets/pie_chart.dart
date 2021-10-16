import 'dart:math';

import 'package:code_forces_tracker/models/cflanguagedata.dart';
import 'package:code_forces_tracker/models/cfverdictsdata.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class CFPieChart extends StatefulWidget {
  final List<CFLanguageData>? languagesData;
  final List<CFVerdictsData>? verdictsData;
  final String chartTitle;
  final String id;
  const CFPieChart({
    Key? key,
    this.languagesData,
    this.verdictsData,
    required this.id,
    required this.chartTitle,
  })  : assert(
          languagesData == null || verdictsData == null,
          'Chart has to display a specific type of data',
        ),
        super(key: key);

  @override
  State<CFPieChart> createState() => _CFPieChartState();
}

class _CFPieChartState extends State<CFPieChart>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return charts.PieChart<Object>(
      [
        charts.Series<dynamic, int>(
          id: widget.id,
          domainFn: (datum, _) => datum.value,
          measureFn: (datum, _) => datum.value,
          data: (widget.languagesData ?? widget.verdictsData)!,
          labelAccessorFn: (datum, _) {
            if (datum is CFVerdictsData) {
              return EnumToString.convertToString(datum.verdict);
            } else {
              return datum.title;
            }
          },
          measureOffsetFn: (datum, _) => datum.value,
        ),
      ],
      defaultRenderer: charts.ArcRendererConfig(
        arcRendererDecorators: [
          charts.ArcLabelDecorator(),
        ],
        startAngle: -1 / 2.1 * pi,
        arcLength: 2 * pi,
      ),
      behaviors: [
        charts.DatumLegend(
          position: charts.BehaviorPosition.bottom,
        ),
        charts.ChartTitle(
          widget.chartTitle,
          titleStyleSpec: const charts.TextStyleSpec(
            color: charts.Color.black,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
