import 'package:code_forces_tracker/models/cfsubmissions.dart';
import 'package:code_forces_tracker/models/thememode.dart';
import 'package:code_forces_tracker/notifiers/submissions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final submissionsProvider = StateNotifierProvider.autoDispose
    .family<SubmissionsNotifier, CFSubmissions, String>(
  (
    _ref,
    String handle,
  ) {
    return SubmissionsNotifier(handle);
  },
);

final themeModeProvider =
    FutureProvider.autoDispose.family<ThemeMode, ThemeModeUseCase>(
  (ref, usecase) async {
    final prefs = await SharedPreferences.getInstance();
    if (usecase is ThemeModeLoad) {
      late ThemeMode state;
      if (prefs.containsKey('themeMode')) {
        final mode = prefs.getString('themeMode')!;
        for (final val in ThemeMode.values) {
          if (mode == val.toString()) {
            state = val;
          }
        }
      } else {
        state = ThemeMode.system;
        prefs.setString('themeMode', ThemeMode.system.toString());
      }
      return state;
    } else {
      final casted = usecase as ThemeModeSet;
      prefs.setString('themeMode', casted.themeMode.toString());
      return casted.themeMode;
    }
  },
);

