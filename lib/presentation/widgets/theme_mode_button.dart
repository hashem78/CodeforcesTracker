import 'package:code_forces_tracker/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ThemeModeActionButton extends ConsumerWidget {
  const ThemeModeActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final icon = switch (themeMode) {
      ThemeMode.system =>
        MediaQuery.of(context).platformBrightness == Brightness.dark
            ? Icons.wb_sunny
            : Icons.wb_cloudy,
      ThemeMode.dark => Icons.wb_sunny,
      ThemeMode.light => Icons.wb_cloudy,
    };
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Consumer(
              builder: (context, dialogRef, _) {
                final dialogThemeMode = dialogRef.watch(themeModeProvider);
                return Dialog(
                  child: RadioGroup<ThemeMode>(
                    groupValue: dialogThemeMode,
                    onChanged: (ThemeMode? val) {
                      if (val == null) return;
                      dialogRef.read(themeModeProvider.notifier).set(val);
                    },
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: const <Widget>[
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.system,
                          title: Text('System'),
                        ),
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.light,
                          title: Text('Light'),
                        ),
                        RadioListTile<ThemeMode>(
                          value: ThemeMode.dark,
                          title: Text('Dark'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
