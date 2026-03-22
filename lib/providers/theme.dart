import 'package:code_forces_tracker/providers/prefs.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme.g.dart';

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
    prefs.setString('themeModex', mode.name);
  }

  void _load() {
    final prefs = ref.read(prefsProvider);
    if (prefs.containsKey('themeModex')) {
      state = ThemeMode.values.byName(prefs.getString('themeModex')!);
    }
  }
}
