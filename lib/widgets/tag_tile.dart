import 'package:flutter/material.dart';

class TagTile extends StatelessWidget {
  final Color? color;
  final String? text;
  TagTile({this.color, this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 80,top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            radius: 5,
            backgroundColor: color,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            text!,
            style: TextStyle(color: color,fontWeight: FontWeight.bold),

          ),
        ],
      ),
    );
  }
}
