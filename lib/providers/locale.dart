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
      final locale = AppLocaleUtils.parse(saved);
      // Eagerly load the deferred locale
      locale.build().then((t) => state = t);
    }
    return AppLocale.en.buildSync();
  }

  AppLocale get currentLocale => AppLocale.values.firstWhere((l) => l.languageCode == state.$meta.locale.languageCode);

  Future<void> setLocale(AppLocale locale) async {
    state = await locale.build();
    ref.read(prefsProvider).setString(_prefsKey, locale.languageCode);
  }
}
