import 'package:auto_route/auto_route.dart';
import 'package:code_forces_tracker/core/app_sizing.dart';
import 'package:code_forces_tracker/providers/locale.dart';
import 'package:code_forces_tracker/router.dart';
import 'package:code_forces_tracker/presentation/widgets/statistics_tab.dart';
import 'package:code_forces_tracker/presentation/widgets/submissions_tab.dart';
import 'package:code_forces_tracker/presentation/widgets/tab_bar_heading.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class MainScreen extends ConsumerWidget {
  const MainScreen({super.key, @PathParam('handle') required this.handle});
  final String handle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(localeProvider);
    final short = context.shortScreen;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: short ? null : Text(t.appTitle),
          toolbarHeight: short ? 0 : kToolbarHeight,
          actions: short
              ? null
              : [
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => context.router.push(const SettingsRoute()),
                  ),
                ],
          bottom: TabBar(
            tabs: [
              TabBarHeading(iconData: Icons.mail, title: t.main.submissions),
              TabBarHeading(
                title: t.main.statistics,
                iconData: Icons.arrow_upward,
              ),
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
