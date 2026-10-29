import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../resources/generated/l10n.dart';

final localeProvider = NotifierProvider<LocaleProvider, Locale>(
  LocaleProvider.new,
);

class LocaleProvider extends Notifier<Locale> {
  @override
  Locale build() => SupportLocale.en;

  void setLocale(Locale locale) {
    if (!SupportLocale.support.contains(locale)) {
      return;
    }
    state = locale;
  }

  void clearLocale() {
    state = SupportLocale.en;
  }
}

class SupportLocale {
  static const Locale en = Locale('en');
  static const Locale vn = Locale('vi');

  /// The ARB files are the single source: adding `intl_xx.arb` adds a locale.
  static List<Locale> get support => S.delegate.supportedLocales;
}
