import 'package:code_forces_tracker/providers/statistics.dart';
import 'package:code_forces_tracker/presentation/widgets/pie_chart.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StatisticsTab extends HookConsumerWidget {
  const StatisticsTab({super.key, required this.handle});
  final String handle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final asyncData = ref.watch(statisticsProvider(handle));
    return switch (asyncData) {
      AsyncLoading() => const Center(child: CircularProgressIndicator()),
      AsyncError() => const Center(child: Text('An Error Occured')),
      AsyncData(:final value) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(statisticsProvider(handle));
          },
          child: Scrollbar(
            thumbVisibility: true,
            controller: pageController,
            child: PageView(
              controller: pageController,
              scrollDirection: Axis.vertical,
              restorationId: 'a',
              children: [
                CFPieChart(
                  key: const Key('languages'),
                  chartTitle: 'Languages',
                  languagesData: value.$1,
                  id: 'l',
                ),
                CFPieChart(
                  key: const Key('verdicts'),
                  verdictsData: value.$2,
                  chartTitle: 'Verdicts',
                  id: 'v',
                ),
              ],
            ),
          ),
        ),
    };
  }
}
