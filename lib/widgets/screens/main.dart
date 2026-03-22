import 'package:code_forces_tracker/models/cfsubmission.dart';
import 'package:code_forces_tracker/notifiers/languages.dart';
import 'package:code_forces_tracker/remote.dart';

import 'package:code_forces_tracker/providers.dart';
import 'package:code_forces_tracker/widgets/widgets/pie_chart.dart';
import 'package:code_forces_tracker/widgets/widgets/tab_bar_heading.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.handle});
  final String handle;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CodeForces Tracker'),
          actions: const [ThemeModeActionButton()],
          bottom: const TabBar(
            tabs: [
              TabBarHeading(iconData: Icons.mail, title: 'Submissions'),
              TabBarHeading(title: 'Statistics', iconData: Icons.arrow_upward),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            LatestSubmissionsTab(handle: handle),
            StatisticsTab(handle: handle),
          ],
        ),
      ),
    );
  }
}

class ThemeModeActionButton extends ConsumerWidget {
  const ThemeModeActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final icon = switch (themeMode) {
      ThemeMode.system =>
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Icons.wb_sunny
            : Icons.wb_cloudy,
      ThemeMode.dark => Icons.wb_sunny,
      ThemeMode.light => Icons.wb_cloudy,
    };
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Consumer(
              builder: (context, dialogRef, _) {
                final dialogThemeMode = dialogRef.watch(themeModeProvider);
                return Dialog(
                  child: RadioGroup<ThemeMode>(
                    groupValue: dialogThemeMode,
                    onChanged: (ThemeMode? val) {
                      if (val == null) return;
                      dialogRef.read(themeModeProvider.notifier).set(val);
                    },
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const <Widget>[
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.system,
                          title: Text('System'),
                        ),
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.light,
                          title: Text('Light'),
                        ),
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.dark,
                          title: Text('Dark'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

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

class LatestSubmissionsTab extends HookWidget {
  const LatestSubmissionsTab({super.key, required this.handle});
  final String handle;

  @override
  Widget build(BuildContext context) {
    final filters = useMemoized(() => <CFSubmissionVerdict>{}, [handle]);
    final repository = useMemoized(
      () => CFRepository(handle: handle),
      [handle],
    );

    final nextFrom = useValueNotifier<int?>(1);
    final pagingController = useMemoized(
      () {
        const pageSize = 10;
        return PagingController<int, CFSubmission>(
          getNextPageKey: (state) => nextFrom.value,
          fetchPage: (pageKey) async {
            var currentFrom = pageKey;
            final allMatched = <CFSubmission>[];
            const maxAttempts = 5;
            for (var attempt = 0; attempt < maxAttempts; attempt++) {
              if (attempt > 0) {
                await Future.delayed(const Duration(milliseconds: 500));
              }
              final result = await repository.getUserStatus(
                filters: filters,
                from: currentFrom,
                count: pageSize,
              );
              allMatched.addAll(result.$1);
              currentFrom += pageSize;
              if (result.$2 == GetUserState.normal) {
                nextFrom.value = null;
                return allMatched;
              }
              if (allMatched.isNotEmpty) {
                nextFrom.value = currentFrom;
                return allMatched;
              }
            }
            nextFrom.value = currentFrom;
            return allMatched;
          },
        );
      },
      [handle],
    );

    useEffect(() => pagingController.dispose, [pagingController]);

    final pagingState = useValueListenable(pagingController);

    return RefreshIndicator(
      onRefresh: () async {
        nextFrom.value = 1;
        pagingController.refresh();
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.width / 7,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: CFSubmissionVerdict.values.map<Widget>((e) {
                  return FilteringWidgetButton(
                    pagingController: pagingController,
                    filters: filters,
                    nextFrom: nextFrom,
                    verdict: e,
                  );
                }).toList(),
              ),
            ),
          ),
          PagedSliverList<int, CFSubmission>(
            state: pagingState,
            fetchNextPage: pagingController.fetchNextPage,
            builderDelegate: PagedChildBuilderDelegate<CFSubmission>(
              itemBuilder: (context, item, index) {
                return ListTile(
                  title: Text(item.problem.name),
                  onTap: () async {
                    if (item.url != null) {
                      final uri = Uri.parse(item.url!);
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      }
                    }
                  },
                  subtitle: Text(
                    'Verdict: ${item.verdict != null ? EnumToString.convertToString(item.verdict) : 'unavailable'}',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class FilteringWidgetButton extends HookWidget {
  const FilteringWidgetButton({
    super.key,
    required this.verdict,
    required this.pagingController,
    required this.filters,
    required this.nextFrom,
  });
  final CFSubmissionVerdict verdict;
  final PagingController<int, CFSubmission> pagingController;
  final Set<CFSubmissionVerdict> filters;
  final ValueNotifier<int?> nextFrom;

  @override
  Widget build(BuildContext context) {
    final isActive = useState(false);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: OutlinedButton(
        onPressed: () {
          if (!isActive.value) {
            filters.add(verdict);
          } else {
            filters.remove(verdict);
          }
          nextFrom.value = 1;
          pagingController.refresh();
          isActive.value = !isActive.value;
        },
        child: Text(
          EnumToString.convertToString(verdict),
          style: TextStyle(
            color: isActive.value ? Colors.grey : Colors.blue,
          ),
        ),
      ),
    );
  }
}
