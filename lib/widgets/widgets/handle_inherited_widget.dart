import 'package:flutter/material.dart';

class HandleInheritedWidget extends InheritedWidget {
  final String handle;
  const HandleInheritedWidget(
    Widget child,
    this.handle, {
    Key? key,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(covariant HandleInheritedWidget oldWidget) {
    return oldWidget.handle != handle;
  }

  static HandleInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HandleInheritedWidget>();
  }
}
