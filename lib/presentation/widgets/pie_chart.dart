import 'dart:math';

import 'package:code_forces_tracker/models/cflanguagedata.dart';
import 'package:code_forces_tracker/models/cfverdictsdata.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class CFPieChart extends StatefulWidget {
  final List<CFLanguageData>? languagesData;
  final List<CFVerdictsData>? verdictsData;
  final String chartTitle;
  final String id;
  const CFPieChart({
    super.key,
    this.languagesData,
    this.verdictsData,
    required this.id,
    required this.chartTitle,
  }) : assert(
         languagesData == null || verdictsData == null,
         'Chart has to display a specific type of data',
       );

  @override
  State<CFPieChart> createState() => _CFPieChartState();
}

class _CFPieChartState extends State<CFPieChart>
    with AutomaticKeepAliveClientMixin {

  List<PieChartSectionData> _buildSections() {
    final random = Random(42);
    if (widget.languagesData != null) {
      return widget.languagesData!.map((data) {
        final color = Color.fromARGB(
          255,
          random.nextInt(200) + 55,
          random.nextInt(200) + 55,
          random.nextInt(200) + 55,
        );
        return PieChartSectionData(
          value: data.value.toDouble(),
          title: data.title,
          color: color,
          radius: 100,
          titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
        );
      }).toList();
    } else {
      return widget.verdictsData!.map((data) {
        final color = Color.fromARGB(
          255,
          random.nextInt(200) + 55,
          random.nextInt(200) + 55,
          random.nextInt(200) + 55,
        );
        return PieChartSectionData(
          value: data.value.toDouble(),
          title: data.verdict.name,
          color: color,
          radius: 100,
          titleStyle: const TextStyle(fontSize: 10, color: Colors.white),
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.chartTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: PieChart(
            PieChartData(
              sections: _buildSections(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
