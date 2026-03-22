import 'package:code_forces_tracker/i18n/strings.g.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'locale.g.dart';

@Riverpod(keepAlive: true)
class LocaleNotifier extends _$LocaleNotifier {
  @override
  Translations build() => AppLocaleUtils.parse('en').buildSync();

  void setLocale(AppLocale locale) {
    state = locale.buildSync();
  }
}
