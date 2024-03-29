import 'package:code_forces_tracker/models/cfsubmission.dart';

import 'package:code_forces_tracker/providers.dart';
import 'package:code_forces_tracker/remote.dart';
import 'package:code_forces_tracker/widgets/widgets/handle_inherited_widget.dart';
import 'package:code_forces_tracker/widgets/widgets/pie_chart.dart';
import 'package:code_forces_tracker/widgets/widgets/tab_bar_heading.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

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
          actions: const [
            ThemeModeActionButton(),
          ],
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
            StatisticsTab(),
          ],
        ),
      ),
    );
  }
}

class ThemeModeActionButton extends HookWidget {
  const ThemeModeActionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeMode = useProvider(themeModeProvider);
    IconData? icon;
    if (themeMode == ThemeMode.system) {
      final currentBrightness = MediaQuery.of(context).platformBrightness;
      if (currentBrightness == Brightness.dark) {
        icon = Icons.wb_sunny;
      } else {
        icon = Icons.wb_cloudy;
      }
    } else if (themeMode == ThemeMode.dark) {
      icon = Icons.wb_sunny;
    } else {
      icon = Icons.wb_cloudy;
    }
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            final themeMode = context.read(themeModeProvider);
            return Dialog(
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: themeMode,
                    title: const Text('System'),
                    onChanged: (ThemeMode? val) {
                      context
                          .read(themeModeProvider.notifier)
                          .set(ThemeMode.system);
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.light,
                    groupValue: themeMode,
                    title: const Text('Light'),
                    onChanged: (ThemeMode? val) {
                      context
                          .read(themeModeProvider.notifier)
                          .set(ThemeMode.light);
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.dark,
                    groupValue: themeMode,
                    title: const Text('Dark'),
                    onChanged: (ThemeMode? val) {
                      context
                          .read(themeModeProvider.notifier)
                          .set(ThemeMode.dark);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class StatisticsTab extends StatefulHookWidget {
  const StatisticsTab({Key? key}) : super(key: key);

  @override
  State<StatisticsTab> createState() => _LanguagesTabState();
}

class _LanguagesTabState extends State<StatisticsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final handle = HandleInheritedWidget.of(context)!.handle;
    context.read(languagesProvider(handle).notifier).fetchData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final handle = HandleInheritedWidget.of(context)!.handle;
    final data = useProvider(languagesProvider(handle));
    return data.when(
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      data: (data) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read(languagesProvider(handle).notifier).fetchData();
          },
          child: Scrollbar(
            isAlwaysShown: true,
            child: PageView(
              scrollDirection: Axis.vertical,
              children: [
                CFPieChart(
                  key: const Key('languages'),
                  chartTitle: 'Languages',
                  languagesData: data.item1,
                  id: 'l',
                ),
                CFPieChart(
                  key: const Key('verdicts'),
                  verdictsData: data.item2,
                  chartTitle: 'Verdicts',
                  id: 'v',
                ),
              ],
              restorationId: 'a',
            ),
          ),
        );
      },
      error: (error) {
        return const Center(
          child: Text('An Error Occured'),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
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
    final handle = HandleInheritedWidget.of(context)!.handle;
    final submissionsNotifier = context.read(
      submissionsProvider(handle).notifier,
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
    final handle = HandleInheritedWidget.of(context)!.handle;
    final submissions = useProvider(submissionsProvider(handle));

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
//Consumer(
//   builder: (context, watch, _) {
//     IconData? icon;
//     final themeMode = watch(themeModeProvider);
//     if (themeMode == ThemeMode.system) {
//       final currentBrightness =
//           MediaQuery.of(context).platformBrightness;
//       if (currentBrightness == Brightness.dark) {
//         icon = Icons.wb_sunny;
//       } else {
//         icon = Icons.wb_cloudy;
//       }
//     } else if (themeMode == ThemeMode.dark) {
//       icon = Icons.wb_sunny;
//     } else {
//       icon = Icons.wb_cloudy;
//     }
//     return IconButton(
//       onPressed: () {
//         final notifier = context.read(themeModeProvider.notifier);
//         if (themeMode == ThemeMode.system) {
//           final currentBrightness =
//               MediaQuery.of(context).platformBrightness;
//           if (currentBrightness == Brightness.dark) {
//             notifier.set(ThemeMode.light);
//           } else {
//             notifier.set(ThemeMode.dark);
//           }
//         } else if (themeMode == ThemeMode.dark) {
//           notifier.set(ThemeMode.light);
//         } else {
//           notifier.set(ThemeMode.dark);
//         }
//       },
//       icon: Icon(icon),
//     );
//   },
// ),
