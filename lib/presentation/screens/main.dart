import 'package:auto_route/auto_route.dart';
import 'package:code_forces_tracker/presentation/widgets/statistics_tab.dart';
import 'package:code_forces_tracker/presentation/widgets/submissions_tab.dart';
import 'package:code_forces_tracker/presentation/widgets/tab_bar_heading.dart';
import 'package:code_forces_tracker/presentation/widgets/theme_mode_button.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MainScreen extends StatelessWidget {
  const MainScreen({super.key, @PathParam('handle') required this.handle});
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
