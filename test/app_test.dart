import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubaseriverpod/app.dart';
import 'package:lubaseriverpod/core/index.dart';
import 'package:lubaseriverpod/data/index.dart';
import 'package:lubaseriverpod/view/features/home/home_page.dart';
import 'package:lubaseriverpod/view/features/login/login_page.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'helpers/fakes.dart';

/// The composition root (router, translations, theme) as `main.dart` runs it.
void main() {
  setUpAll(
    () => VisibilityDetectorController.instance.updateInterval = Duration.zero,
  );

  Future<ProviderContainer> pumpApp(
    WidgetTester tester, {
    required bool loggedIn,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositoryProvider.overrideWithValue(
            FakeRepository(auth: FakeAuthRepository(loggedIn: loggedIn)),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    return ProviderScope.containerOf(tester.element(find.byType(App)));
  }

  testWidgets('starts on Home with a token', (tester) async {
    await pumpApp(tester, loggedIn: true);
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('starts on Login without a token', (tester) async {
    await pumpApp(tester, loggedIn: false);
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('switching the language re-translates the app', (tester) async {
    final container = await pumpApp(tester, loggedIn: true);
    expect(find.text('Home'), findsOneWidget);

    container.read(localeProvider.notifier).setLocale(SupportLocale.vn);
    await tester.pumpAndSettle();

    expect(find.text('Trang chủ'), findsOneWidget);
  });

  testWidgets('switching the theme changes the brightness', (tester) async {
    final container = await pumpApp(tester, loggedIn: true);

    container.read(themeProvider.notifier).setBrightness(Brightness.dark);
    await tester.pumpAndSettle();

    expect(
      Theme.of(tester.element(find.byType(HomePage))).brightness,
      Brightness.dark,
    );
  });
}
