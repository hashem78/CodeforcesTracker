import 'package:flutter/material.dart';

class DarkBeveledCard extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final int? index;
  DarkBeveledCard({this.title, this.subtitle, this.index});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: BeveledRectangleBorder(),
      color: Colors.black,
      child: ListTile(
        leading: Text(
          index.toString(),
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        title: Text(
          title!,
        ),
        subtitle: Text(
          subtitle!,
        ),
      ),
    );
  }
}
