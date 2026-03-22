import 'package:auto_route/auto_route.dart';
import 'package:code_forces_tracker/i18n/strings.g.dart';
import 'package:code_forces_tracker/providers/locale.dart';
import 'package:code_forces_tracker/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

@RoutePage()
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(t.settings.title)),
      body: ListView(
        children: [
          _ThemeSection(t: t, themeMode: themeMode),
          const Divider(),
          _LanguageSection(t: t, currentLocale: localeNotifier.currentLocale),
        ],
      ),
    );
  }
}

class _ThemeSection extends ConsumerWidget {
  const _ThemeSection({required this.t, required this.themeMode});
  final Translations t;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            t.settings.theme,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        RadioGroup<ThemeMode>(
          groupValue: themeMode,
          onChanged: (ThemeMode? val) {
            if (val != null) {
              ref.read(themeModeProvider.notifier).set(val);
            }
          },
          child: Column(
            children: [
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                title: Text(t.theme.system),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                title: Text(t.theme.light),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                title: Text(t.theme.dark),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LanguageSection extends ConsumerWidget {
  const _LanguageSection({required this.t, required this.currentLocale});
  final Translations t;
  final AppLocale currentLocale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            t.settings.language,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        RadioGroup<AppLocale>(
          groupValue: currentLocale,
          onChanged: (AppLocale? val) {
            if (val != null) {
              ref.read(localeProvider.notifier).setLocale(val);
            }
          },
          child: Column(
            children: [
              for (final locale in AppLocale.values)
                RadioListTile<AppLocale>(
                  value: locale,
                  title: Text(_localeName(locale)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  String _localeName(AppLocale locale) => switch (locale) {
        AppLocale.en => t.settings.languageNames.en,
      };
}
