import 'package:code_forces_tracker/core/verdict_colors.dart';
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

  int get _total {
    if (widget.languagesData != null) {
      return widget.languagesData!.fold(0, (sum, d) => sum + d.value);
    }
    return widget.verdictsData!.fold(0, (sum, d) => sum + d.value);
  }

  List<_ChartEntry> get _entries {
    if (widget.languagesData != null) {
      return widget.languagesData!.asMap().entries.map((e) {
        final color = languageColorPalette[e.key % languageColorPalette.length];
        return _ChartEntry(
          label: e.value.title,
          value: e.value.value,
          color: color,
        );
      }).toList();
    }
    return widget.verdictsData!.map((d) {
      return _ChartEntry(
        label: d.verdict.name,
        value: d.value,
        color: verdictColor(d.verdict),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final entries = _entries;
    final total = _total;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            widget.chartTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        Expanded(
          child: PieChart(
            PieChartData(
              sections: entries.map((e) {
                final pct = e.value / total * 100;
                final showLabel = pct >= 5;
                return PieChartSectionData(
                  value: e.value.toDouble(),
                  title: showLabel ? '${pct.toStringAsFixed(1)}%' : '',
                  color: e.color,
                  radius: 90,
                  titleStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 36,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Wrap(
            spacing: 12,
            runSpacing: 6,
            alignment: WrapAlignment.center,
            children: entries.map((e) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: e.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${e.label} (${e.value})',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _ChartEntry {
  final String label;
  final int value;
  final Color color;

  const _ChartEntry({
    required this.label,
    required this.value,
    required this.color,
  });
}
