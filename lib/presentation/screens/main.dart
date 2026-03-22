import 'package:auto_route/auto_route.dart';
import 'package:code_forces_tracker/providers/locale.dart';
import 'package:code_forces_tracker/presentation/widgets/statistics_tab.dart';
import 'package:code_forces_tracker/presentation/widgets/submissions_tab.dart';
import 'package:code_forces_tracker/presentation/widgets/tab_bar_heading.dart';
import 'package:code_forces_tracker/presentation/widgets/theme_mode_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key, @PathParam('handle') required this.handle});
  final String handle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(localeProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.appTitle),
          actions: const [ThemeModeActionButton()],
          bottom: TabBar(
            tabs: [
              TabBarHeading(iconData: Icons.mail, title: t.main.submissions),
              TabBarHeading(title: t.main.statistics, iconData: Icons.arrow_upward),
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
