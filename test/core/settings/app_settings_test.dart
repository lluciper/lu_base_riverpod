import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubaseriverpod/core/index.dart';

void main() {
  group('localeProvider', () {
    test('defaults to English and switches to a supported locale', () {
      final container = ProviderContainer.test();
      expect(container.read(localeProvider), SupportLocale.en);

      container.read(localeProvider.notifier).setLocale(SupportLocale.vn);
      expect(container.read(localeProvider), SupportLocale.vn);

      container.read(localeProvider.notifier).clearLocale();
      expect(container.read(localeProvider), SupportLocale.en);
    });

    test('ignores unsupported locales', () {
      final container = ProviderContainer.test();
      container.read(localeProvider.notifier).setLocale(const Locale('ja'));
      expect(container.read(localeProvider), SupportLocale.en);
    });
  });

  test('themeProvider defaults to light, can switch and reset', () {
    final container = ProviderContainer.test();
    expect(container.read(themeProvider), Brightness.light);

    container.read(themeProvider.notifier).setBrightness(Brightness.dark);
    expect(container.read(themeProvider), Brightness.dark);

    container.read(themeProvider.notifier).clearBrightness();
    expect(container.read(themeProvider), Brightness.light);
  });
}
