import 'package:code_forces_tracker/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

extension TranslationsLocale on Translations {
  Locale get flutterLocale => Locale($meta.locale.languageCode);
}

Iterable<Locale> get supportedLocales =>
    AppLocale.values.map((l) => Locale(l.languageCode));

const localizationsDelegates = [
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  FormBuilderLocalizations.delegate,
];
