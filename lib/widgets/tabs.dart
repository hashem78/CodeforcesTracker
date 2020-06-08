import 'package:flutter/material.dart';
import 'package:my_design/screens/charted_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_design/data/centralized_data.dart';

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
    var data = Provider.of<Data>(context);
    List<ChartedScreen> screens = [
      ChartedScreen(data: data.tags,top10data:data.top10Tags),
      ChartedScreen(data: data.langs,top10data: data.top10Langs),
      ChartedScreen(data: data.verdicts,top10data: data.top10Verdicts,),
    ];
    return SafeArea(
      child: DefaultTabController(
        length: screens.length,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: TabBar(
              tabs: tabList,
            ),
          ),
          body: TabBarView(
            children: screens,
          ),
        ),
      ),
    );
  }
}
