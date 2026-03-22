import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences prefs(Ref ref) {
  throw Exception('Provider was not initialized');
}

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() {
    _load();
    return ThemeMode.system;
  }

  void set(ThemeMode mode) {
    final prefs = ref.read(prefsProvider);
    state = mode;
    prefs.setString('themeModex', EnumToString.convertToString(mode));
  }

  void _load() {
    final prefs = ref.read(prefsProvider);
    if (prefs.containsKey('themeModex')) {
      state = EnumToString.fromString(
        ThemeMode.values,
        prefs.getString('themeModex')!,
      )!;
    }
  }
}
