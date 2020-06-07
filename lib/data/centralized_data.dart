import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_design/constants.dart';
import 'package:random_color/random_color.dart';

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

class Data with ChangeNotifier {
  final Map<String, ColorTag> langs = {};
  final Map<String, ColorTag> tags = {};

  final Map<String, List<String>> top10Tags = {};
  final Map<String, List<String>> top10Langs = {};
  final Set<String> _problemNames = {};

  final ChangableString _handel = ChangableString();
  int _tagColorIndex = 0;
  int _langColorIndex = 0;

  void updateHandle(String newHandel) {
    _handel.chageTo(newHandel);
  }

  Map<String, dynamic> _results;

  void pullTags() {
    for (var submission in _results['result']) {
      String problemName = submission["problem"]["name"] as String;

      List<String> problemTags =
          submission["problem"]["tags"].cast<String>().toList();
      String verdict = (submission["verdict"]) as String;
      if (!_problemNames.contains(problemName) && verdict == "OK") {
        _problemNames.add(problemName);
        addTags(problemTags);
        if (top10Tags.length < 10) top10Tags[problemName] = problemTags;
      }
    }
  }

  void pullLangs() {
    _problemNames.clear();
    for (var submission in _results['result']) {
      String problemName = submission["problem"]["name"] as String;
      String language = submission["programmingLanguage"] as String;

      String verdict = (submission["verdict"]) as String;
      addLang(language);
      if (!_problemNames.contains(problemName) && verdict == "OK") {
        _problemNames.add(problemName);
        if (top10Langs.length < 10) {
          if (top10Langs[problemName] == null) top10Langs[problemName] = [];
          top10Langs[problemName].add(language);
        }
      }
    }
  }

  Future<void> pullDataFromCF() async {
    String url =
        "https://codeforces.com/api/user.status?handle=${_handel.data}";
    http.Response response = await http.get(url);
    _results = json.decode(response.body);
    pullTags();
    pullLangs();

    notifyListeners();
  }

  void addLang(String language) {
    if (!langs.containsKey(language)) {
      langs[language] = ColorTag(
        color: _langColorIndex < 50
            ? kcolors[_langColorIndex++]
            : RandomColor().randomColor(),
        reps: 1,
      );
    } else {
      langs[language].reps++;
    }
  }

  void addTags(List<String> listOfTags) {
    for (String tag in listOfTags)
      if (!tags.containsKey(tag)) {
        tags[tag] = ColorTag(
          reps: 1,
          color: _tagColorIndex < kcolors.length
              ? kcolors[_tagColorIndex++]
              : RandomColor().randomColor(
                  colorSaturation: ColorSaturation.highSaturation,
                ),
        );
      } else {
        tags[tag].reps++;
      }
  }
}
