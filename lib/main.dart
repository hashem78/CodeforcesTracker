import 'package:code_forces_tracker/widgets/screens/landing.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:code_forces_tracker/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      themeMode: ThemeMode.system,
      home: Scaffold(body: Center(child: CircularProgressIndicator())),
    ),
  );
  final prefrences = await SharedPreferences.getInstance();

  runApp(ProviderScope(overrides: [prefsProvider.overrideWithValue(prefrences)], child: const MyApp()));
}

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      themeMode: themeMode,
      theme: ThemeData(
        brightness: themeMode == ThemeMode.system
            ? PlatformDispatcher.instance.platformBrightness
            : themeMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light,
      ),
      home: const LandingScreen(),
    );
  }
}
