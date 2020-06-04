import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'important_data.dart';

class CircularListView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(140),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: Provider.of<ImportantData>(context).tags.length,
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              Provider.of<ImportantData>(context).tags.keys.elementAt(index),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 40,
                fontWeight: FontWeight.w900,
              ),
            ),
            width: 300,
            color: Provider.of<ImportantData>(context)
                .tags
                .values
                .elementAt(index)
                .color,
          );
        },
      ),
    );
  }
}
