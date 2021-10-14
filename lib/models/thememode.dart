import 'package:flutter/material.dart';

abstract class ThemeModeUseCase {
  const ThemeModeUseCase();
}

class ThemeModeSet extends ThemeModeUseCase {
  final ThemeMode themeMode;
  const ThemeModeSet(this.themeMode);
}

class ThemeModeLoad extends ThemeModeUseCase {
  const ThemeModeLoad();
}