import 'package:code_forces_tracker/models/cfstatisticsstate.dart';
import 'package:code_forces_tracker/models/cfsubmissions.dart';
import 'package:code_forces_tracker/notifiers/languages.dart';
import 'package:code_forces_tracker/notifiers/submissions.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/cfhandle.dart';
import 'notifiers/handle.dart';

final prefsProvider = Provider<SharedPreferences>((ref) {
  throw Exception('Provider was not initialized');
});

final submissionsProvider = StateNotifierProvider.autoDispose
    .family<SubmissionsNotifier, CFSubmissions, String>(
  (
    _ref,
    String handle,
  ) {
    return SubmissionsNotifier(handle);
  },
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier({
    required this.ref,
  }) : super(ThemeMode.system);
  final ProviderReference ref;
  void set(ThemeMode mode) {
    final prefs = ref.read(prefsProvider);
    print(mode);
    state = mode;
    prefs.setString('themeModex', EnumToString.convertToString(mode));
  }

  Future<void> load() async {
    final prefs = ref.read(prefsProvider);
    if (prefs.containsKey('themeModex')) {
      set(
        EnumToString.fromString(
          ThemeMode.values,
          prefs.getString(
            'themeModex',
          )!,
        )!,
      );
    } else {
      prefs.setString(
        'themeModex',
        EnumToString.convertToString(ThemeMode.system),
      );
    }
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) {
    return ThemeModeNotifier(
      ref: ref,
    )..load();
  },
);

final languagesProvider = StateNotifierProvider.autoDispose
    .family<CFStatisticsNotifier, CFStatisticsState, String>(
  (ref, handle) {
    return CFStatisticsNotifier(handle);
  },
);
final handleProvider =
    StateNotifierProvider.autoDispose<HandleNotifier, CFHandle>(
  (ref) {
    return HandleNotifier();
  },
);
