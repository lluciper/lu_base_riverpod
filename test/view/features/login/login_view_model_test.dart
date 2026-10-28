import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lubaseriverpod/core/index.dart';
import 'package:lubaseriverpod/data/index.dart';
import 'package:lubaseriverpod/view/features/login/login_state.dart';
import 'package:lubaseriverpod/view/features/login/login_view_model.dart';

import '../../../helpers/fakes.dart';

void main() {
  final provider = NotifierProvider.autoDispose<LoginViewModel, LoginState>(
    LoginViewModel.new,
  );

  test('isValidButton is true only when email and password are valid', () {
    final container = ProviderContainer.test();
    container.listen(provider, (_, _) {});
    final viewModel = container.read(provider.notifier);

    expect(container.read(provider).isValidButton, isFalse);

    viewModel.onEmailChanged('user@example.com');
    expect(container.read(provider).isValidButton, isFalse);

    viewModel.onPasswordChanged('12345678');
    expect(container.read(provider).isValidButton, isTrue);
  });

  test('onChangeThemeMode updates themeProvider', () {
    final container = ProviderContainer.test();
    container.read(provider.notifier).onChangeThemeMode(Brightness.dark);
    expect(container.read(themeProvider), Brightness.dark);
  });

  test(
    'onPressLogin sends the form values and rethrows repository errors',
    () async {
      final auth = FakeAuthRepository();
      final container = ProviderContainer.test(
        overrides: [
          repositoryProvider.overrideWithValue(FakeRepository(auth: auth)),
        ],
      );
      container.listen(provider, (_, _) {});
      final viewModel = container.read(provider.notifier)
        ..onEmailChanged('user@example.com')
        ..onPasswordChanged('12345678');

      await viewModel.onPressLogin();
      expect(auth.requests, hasLength(1));
      expect(auth.requests.single.email, 'user@example.com');
      expect(auth.requests.single.password, '12345678');

      auth.onLogin = (_) async => throw Exception('401');
      await expectLater(viewModel.onPressLogin(), throwsException);
    },
  );
}
