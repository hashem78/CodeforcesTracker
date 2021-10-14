import 'package:code_forces_tracker/models/thememode.dart';
import 'package:code_forces_tracker/widgets/screens/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:code_forces_tracker/providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyApp(),
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
    final theme = useProvider(themeModeProvider(const ThemeModeLoad()));
    return theme.when(
      data: (themeMode) {
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
      },
      loading: () {
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        print(error);
        print(stackTrace);
        return const MaterialApp(
          home: Scaffold(
            body: Center(
              child: Text('Failed to load assets from storage'),
            ),
          ),
        );
      },
    );
  }
}







