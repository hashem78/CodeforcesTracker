import 'package:flutter/material.dart';

class ColorTag {
  Color color;
  int reps;
  ColorTag({this.color, this.reps});
}

class ChangableString {
  String data = "";
  void chageTo(String data) {
    this.data = data;
  }
}

abstract class DataField {
  final Map<String, ColorTag> tags = {};
  final Map<String, List<String>> top10 = {};
  final ChangableString handel = ChangableString();

  void updateHandle(String newHandel) {
    handel.chageTo(newHandel);
  }
}
