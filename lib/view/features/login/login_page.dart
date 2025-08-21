import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lubaseriverpod/resources/generated/assets.gen.dart';

import '../../../../utils/extensions/extensions.dart';
import '../../../core/index.dart';
import '../../../resources/generated/l10n.dart';
import '../../../resources/resources.dart';
import 'components/login_panel.dart';
import 'view_model/login_state.dart';
import 'view_model/login_view_model.dart';

final _provider = StateNotifierProvider.autoDispose<LoginViewModel, LoginState>(
      (ref) => LoginViewModel(),
    );

class LoginPage extends BasePage {
  const LoginPage({super.key});

  @override
  BasePageState<LoginPage, LoginViewModel> createState() => _LoginPageState();
}

class _LoginPageState extends BasePageState<LoginPage, LoginViewModel> {
  @override
  LoginViewModel get viewModel => _provider.viewModel(ref);

  @override
  Widget buildBody(BuildContext context) => SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 64),
          Assets.imageFlutter.image(),
          const SizedBox(height: 16),
          LoginPanel(provider: _provider, onPressLogin: onPressLogin),
          const SizedBox(height: 16),
          Text(
            S.current.language,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.colors.text,
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                child: Text(S.current.language_english),
                onPressed: () =>
                    viewModel.onChangeLanguage(ref, SupportLocale.en),
              ),
              ElevatedButton(
                child: Text(S.current.language_vietnam),
                onPressed: () =>
                    viewModel.onChangeLanguage(ref, SupportLocale.vn),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            S.current.theme_mode,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.colors.text,
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                child: Text(S.current.dark_mode),
                onPressed: () =>
                    viewModel.onChangeThemeMode(ref, Brightness.dark),
              ),

              ElevatedButton(
                child: Text(S.current.light_mode),
                onPressed: () =>
                    viewModel.onChangeThemeMode(ref, Brightness.light),
              ),
              ElevatedButton(
                child: Text('S.current.light_mode'),
                onPressed: () {
                  appRouter.pop(true);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );

  void onPressLogin() {
    _provider
        .viewModel(ref)
        .onPressLogin(ref)
        .subscribeLoadingFullScreen(this)
        .subscribeHandleError(this);
  }
}
