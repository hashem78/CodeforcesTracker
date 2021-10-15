import 'package:code_forces_tracker/widgets/screens/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:code_forces_tracker/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    ),
  );
  final prefrences = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        prefsProvider.overrideWithValue(prefrences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends HookWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    final themeMode = useProvider(themeModeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        brightness: themeMode == ThemeMode.system
            ? SchedulerBinding.instance?.window.platformBrightness
            : themeMode == ThemeMode.dark
                ? Brightness.dark
                : Brightness.light,
      ),
      home: const LandingScreen(),
    );
  }
}
