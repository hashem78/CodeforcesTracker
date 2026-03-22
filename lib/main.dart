import 'dart:ui';

import 'package:code_forces_tracker/providers/locale.dart';
import 'package:code_forces_tracker/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:code_forces_tracker/providers/prefs.dart';
import 'package:code_forces_tracker/providers/theme.dart';
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

  runApp(
    ProviderScope(
      overrides: [prefsProvider.overrideWithValue(prefrences)],
      child: MyApp(),
    ),
  );
}

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    final themeMode = ref.watch(themeModeProvider);
    final t = ref.watch(localeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: t.appTitle,
      themeMode: themeMode,
      theme: ThemeData(
        brightness: themeMode == ThemeMode.system
            ? PlatformDispatcher.instance.platformBrightness
            : themeMode == ThemeMode.dark
            ? Brightness.dark
            : Brightness.light,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FormBuilderLocalizations.delegate,
      ],
      routerConfig: _appRouter.config(),
    );
  }
}
