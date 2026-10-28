import 'dart:ui';

import '../../../core/index.dart';
import '../../../data/index.dart';
import '../../entities/email_entity.dart';
import '../../entities/password_entity.dart';
import 'login_state.dart';

class LoginViewModel extends BaseViewModel<LoginState> {
  @override
  LoginState build() => LoginState.initial();

  void onEmailChanged(String value) {
    state = state.copyWith(email: EmailEntity.create(value));
    _checkValidButton();
  }

  void onPasswordChanged(String value) {
    state = state.copyWith(password: PasswordEntity.create(value));
    _checkValidButton();
  }

  void _checkValidButton() {
    state = state.copyWith(
      isValidButton: state.email.valid && state.password.valid,
    );
  }

  void onChangeThemeMode(Brightness mode) {
    ref.read(themeProvider.notifier).setBrightness(mode);
  }

  void onChangeLanguage(Locale lang) {
    ref.read(localeProvider.notifier).setLocale(lang);
  }

  Future<LoginResponseModel> onPressLogin() => repository.auth.login(
    LoginRequestModel(
      email: state.email.value ?? '',
      password: state.password.value ?? '',
    ),
  );
}
