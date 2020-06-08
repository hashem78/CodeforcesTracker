import 'package:flutter/material.dart';
import 'package:my_design/screens/tag_screen.dart';
import 'package:my_design/screens/languages_screen.dart';
import 'package:my_design/screens/verdicts_screen.dart';

List<Tab> tabList = [
  Tab(
    child: Text("Tags"),
  ),
  Tab(
    child: Text("Languages"),
  ),
  Tab(
    child: Text("Verdicts"),
  ),
];

class MyTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: TabBar(
              tabs: tabList,
            ),
          ),
          body: TabBarView(
            children: [
              TagScreen(),
              LanguageScreen(),
              VerdictScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
