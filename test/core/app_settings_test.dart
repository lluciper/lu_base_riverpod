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

  group('RefreshService', () {
    setUp(RefreshService.clear);

    test(
      'hadRefresh is true only for initialized pages marked for refresh',
      () {
        RefreshService.addPage('HomePage');
        expect(RefreshService.hadRefresh('HomePage'), isFalse);

        RefreshService.addPageInitialized('HomePage');
        expect(RefreshService.hadRefresh('HomePage'), isTrue);

        RefreshService.removePage('HomePage');
        expect(RefreshService.hadRefresh('HomePage'), isFalse);
        RefreshService.removePageInitialized('HomePage');
      },
    );

    test('accepts Type, String and lists of them', () {
      RefreshService.addPageInitialized('int');
      RefreshService.addPageInitialized('A');
      RefreshService.addPageInitialized('B');
      RefreshService.addPage(int);
      RefreshService.addPage(['A', 'B']);
      expect(RefreshService.hadRefresh('int'), isTrue);
      expect(RefreshService.hadRefresh('A'), isTrue);

      RefreshService.removePage([int]);
      expect(RefreshService.hadRefresh('int'), isFalse);
    });

    test('throws on unsupported argument types', () {
      expect(() => RefreshService.addPage(1), throwsException);
      expect(() => RefreshService.removePage(1), throwsException);
    });
  });
}
