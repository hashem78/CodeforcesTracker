import 'package:flutter/material.dart';

class CircularListView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final int? itemCount;
  final Function? itemBuilder;
  CircularListView({this.itemCount,this.itemBuilder});
  

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(140),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: itemBuilder as Widget Function(BuildContext, int),
      ),
    );
  }
}
