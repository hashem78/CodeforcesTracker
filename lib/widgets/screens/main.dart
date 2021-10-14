import 'package:code_forces_tracker/models/cfsubmission.dart';
import 'package:code_forces_tracker/providers.dart';
import 'package:code_forces_tracker/remote.dart';
import 'package:code_forces_tracker/widgets/widgets/tab_bar_heading.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fl_chart/fl_chart.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CodeForces Tracker'),
          bottom: const TabBar(
            tabs: [
              TabBarHeading(
                iconData: Icons.mail,
                title: 'Submissions',
              ),
              TabBarHeading(
                title: 'Statistics',
                iconData: Icons.arrow_upward,
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LatestSubmissionsTab(),
            LanguagesTab(),
          ],
        ),
      ),
    );
  }
}

class LanguagesTab extends StatefulHookWidget {
  const LanguagesTab({Key? key}) : super(key: key);

  @override
  State<LanguagesTab> createState() => _LanguagesTabState();
}

class _LanguagesTabState extends State<LanguagesTab> {
  @override
  void didChangeDependencies() {
    context.read(languagesProvider.notifier).fetchData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final data = useProvider(languagesProvider);
    final touchedIndex = useValueNotifier(-1);
    return data.when(
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      data: (data) {
        return ValueListenableBuilder<int>(
          valueListenable: touchedIndex,
          builder: (context, idx, child) {
            final isTouched = idx != -1;
            List<PieChartSectionData>? copy;
            if (isTouched) {
              copy = [...data];
              copy[idx] = copy[idx].copyWith(
                radius: 170,
                titleStyle: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return PieChart(
              PieChartData(
                centerSpaceRadius: 0,
                sections: isTouched ? copy : data,
                pieTouchData: PieTouchData(
                  touchCallback: (event, pieTouchResponse) {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex.value = -1;
                    } else {
                      touchedIndex.value =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    }
                  },
                ),
              ),
            );
          },
        );
      },
      error: (error) {
        return const Center(
          child: Text('An Error Occured'),
        );
      },
    );
  }
}

class LatestSubmissionsTab extends StatefulHookWidget {
  const LatestSubmissionsTab({Key? key}) : super(key: key);

  @override
  _LatestSubmissionsTabState createState() => _LatestSubmissionsTabState();
}

class _LatestSubmissionsTabState extends State<LatestSubmissionsTab>
    with AutomaticKeepAliveClientMixin {
  final pagingController = PagingController<int, CFSubmission>(firstPageKey: 1);
  @override
  void didChangeDependencies() {
    final submissionsNotifier = context.read(
      submissionsProvider('hashalayan').notifier,
    );
    pagingController.addPageRequestListener(
      (pageKey) {
        submissionsNotifier.getSubmissions(from: pageKey, count: 10);
      },
    );
    submissionsNotifier.getSubmissions();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final submissions = useProvider(submissionsProvider('hashalayan'));

    return submissions.when(
      initial: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      data: (submissions, nextFrom, getUserState) {
        if (getUserState == GetUserState.normal) {
          pagingController.appendLastPage([]);
        } else {
          pagingController.appendPage(submissions, nextFrom);
        }
        return RefreshIndicator(
          onRefresh: () async {
            pagingController.refresh();
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.width / 7,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: CFSubmissionVerdict.values.map<Widget>(
                      (e) {
                        return FilteringWidgetButton(
                          pagingController: pagingController,
                          verdict: e,
                        );
                      },
                    ).toList(),
                  ),
                ),
              ),
              PagedSliverList(
                pagingController: pagingController,
                builderDelegate: PagedChildBuilderDelegate<CFSubmission>(
                  itemBuilder: (context, item, index) {
                    return ListTile(
                      title: Text(item.problem.name),
                      onTap: () async {
                        if (item.url != null) {
                          if (await canLaunch(item.url!)) {
                            await launch(item.url!);
                          }
                        }
                      },
                      subtitle: Text('Verdict: ${getVerdict(item.verdict)}'),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      error: (String? error) {
        return const Center(
          child: Text('Error'),
        );
      },
    );
  }

  String getVerdict(CFSubmissionVerdict? verdict) {
    if (verdict != null) {
      return EnumToString.convertToString(verdict);
    } else {
      return 'unavailable';
    }
  }

  @override
  bool get wantKeepAlive => true;
}

class FilteringWidgetButton extends HookWidget {
  const FilteringWidgetButton({
    Key? key,
    required this.verdict,
    required this.pagingController,
  }) : super(key: key);
  final CFSubmissionVerdict verdict;
  final PagingController pagingController;
  @override
  Widget build(BuildContext context) {
    final isFilteringFor = useValueNotifier(false);
    return Padding(
      padding: const EdgeInsets.only(
        top: 8.0,
        left: 8.0,
        right: 8.0,
      ),
      child: OutlinedButton(
        onPressed: () {
          final notifier =
              context.read(submissionsProvider('hashalayan').notifier);
          if (!isFilteringFor.value) {
            notifier.addFilter(verdict);
          } else {
            notifier.removeFilter(verdict);
          }
          pagingController.refresh();
          isFilteringFor.value = !isFilteringFor.value;
        },
        style: OutlinedButton.styleFrom(),
        child: Text(
          EnumToString.convertToString(verdict),
          style: TextStyle(
            color:
                useValueListenable(isFilteringFor) ? Colors.grey : Colors.blue,
          ),
        ),
      ),
    );
  }
}
