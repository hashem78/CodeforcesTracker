import 'package:code_forces_tracker/i18n/strings.g.dart';
import 'package:code_forces_tracker/providers/prefs.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale.g.dart';

const _prefsKey = 'locale';

@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Translations build() {
    final prefs = ref.read(prefsProvider);
    final saved = prefs.getString(_prefsKey);
    if (saved != null) {
      return AppLocaleUtils.parse(saved).buildSync();
    }
    return AppLocale.en.buildSync();
  }

  AppLocale get currentLocale =>
      AppLocale.values.firstWhere((l) => l.languageCode == state.$meta.locale.languageCode);

  void setLocale(AppLocale locale) {
    state = locale.buildSync();
    ref.read(prefsProvider).setString(_prefsKey, locale.languageCode);
  }
}
