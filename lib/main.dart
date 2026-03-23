import 'package:code_forces_tracker/core/locale_helpers.dart';
import 'package:code_forces_tracker/core/theme_helpers.dart';
import 'package:code_forces_tracker/providers/locale.dart';
import 'package:code_forces_tracker/router.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sizer/sizer.dart';

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
  final preferences = await SharedPreferences.getInstance();

  runApp(ProviderScope(overrides: [prefsProvider.overrideWithValue(preferences)], child: MyApp()));
}

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final t = ref.watch(localeProvider);

    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: scaffoldMessengerKey,
          title: t.appTitle,
          locale: t.flutterLocale,
          supportedLocales: supportedLocales,
          localizationsDelegates: localizationsDelegates,
          themeMode: themeMode,
          theme: lightTheme,
          darkTheme: darkTheme,
          routerConfig: _appRouter.config(),
        );
      },
    );
  }
}
