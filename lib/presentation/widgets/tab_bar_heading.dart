import 'package:code_forces_tracker/core/app_sizing.dart';
import 'package:flutter/material.dart';

class TabBarHeading extends StatelessWidget {
  const TabBarHeading({super.key, required this.title, required this.iconData});
  final String title;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: context.isCompact
          ? Text(title, overflow: TextOverflow.ellipsis)
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(iconData, size: 20),
                const SizedBox(width: 8),
                Flexible(child: Text(title, overflow: TextOverflow.ellipsis)),
              ],
            ),
    );
  }
}
