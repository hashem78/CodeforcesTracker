import 'package:flutter/material.dart';

class TabBarHeading extends StatelessWidget {
  const TabBarHeading({
    Key? key,
    required this.title,
    required this.iconData,
  }) : super(key: key);
  final String title;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(iconData),
          const SizedBox(
            width: 10,
          ),
          Text(title),
        ],
      ),
    );
  }
}