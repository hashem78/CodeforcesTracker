import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_design/constants.dart';
import 'package:provider/provider.dart';
import 'package:random_color/random_color.dart';

class ColorTag {
  Color color;
  int reps;
  ColorTag({this.color, this.reps});
}

class ImportantData with ChangeNotifier {
  final Map<String, ColorTag> tags = {};
  final Map<String, List<String>> top10 = {};

  void updateTop10() async {
    Map<String, List<String>> top10 = {};
    Set<String> problemNames = {};
    String url = "https://codeforces.com/api/user.status?handle=TLE";
    http.Response response = await http.get(url);
    Map<String, dynamic> results = json.decode(response.body);

    int count = 0;
    for (var submission in results["result"]) {
      if (count <= 10) {
        var submissionName = submission["problem"]["name"];
        if (!problemNames.contains(submissionName)) {
          count++;
          problemNames.add(submissionName);
          top10[submissionName] = [];
          for (String tag in submission["problem"]["tags"]) {
            top10[submissionName].add(tag);
          }
        }
      }else{
        break;
      }
    }
    this.top10.clear();
    this.top10.addAll(top10);
    notifyListeners();
  }

  void updateTagsFromCF() async {
    int colorIndex = 0;
    Set<String> problemNames = {};
    final Map<String, ColorTag> tags = {};

    String url = "https://codeforces.com/api/user.status?handle=TLE";
    http.Response response = await http.get(url);
    Map<String, dynamic> results = json.decode(response.body);

    for (var submission in results["result"]) {
      var submissionName = submission["problem"]["name"];
      if (!problemNames.contains(submissionName)) {
        problemNames.add(submissionName);
        for (String tag in submission["problem"]["tags"]) {
          if (!tags.containsKey(tag)) {
            tags[tag] = ColorTag(
                reps: 1,
                color: colorIndex < kcolors.length
                    ? kcolors[colorIndex++]
                    : RandomColor().randomColor(
                        colorSaturation: ColorSaturation.highSaturation));
          } else {
            tags[tag].reps++;
          }
        }
      }
    }
    this.tags.clear();
    this.tags.addAll(tags);
    notifyListeners();
  }
}
