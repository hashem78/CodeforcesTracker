import 'dart:ui';

import 'package:flutter/material.dart';

Brightness brightnessFor(ThemeMode mode) => switch (mode) {
      ThemeMode.system => PlatformDispatcher.instance.platformBrightness,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.light => Brightness.light,
    };
