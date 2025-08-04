import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/index.dart';
import '../../../../resources/generated/l10n.dart';
import '../view_model/login_state.dart';
import '../view_model/login_view_model.dart';

class LoginPanel extends StatelessWidget {
  const LoginPanel({
    required this.provider,
    required this.onPressLogin,
    super.key,
  });

  final ViewModelProvider<LoginViewModel, LoginState> provider;
  final Function() onPressLogin;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Consumer(
        builder: (context, ref, child) => CustomTextFormField(
          hintText: S.current.enter_email,
          labelText: S.current.email,
          keyboardType: TextInputType.emailAddress,
          errorText: provider.listen(ref, (value) => value.email.errorText()),
          onChanged: provider.viewModel(ref).onEmailChanged,
        ),
      ),
      const SizedBox(height: 8),
      Consumer(
        builder: (context, ref, child) => CustomTextFormField(
          hintText: S.current.enter_password,
          labelText: S.current.password,
          keyboardType: TextInputType.text,
          errorText: provider.listen(ref, (value) => value.password.errorText()),
          onChanged: provider.viewModel(ref).onPasswordChanged,
        ),
      ),
      const SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressLogin,
          child: Text(S.current.login_button),
        ),
      ),
    ],
  );
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    required this.keyboardType,
    required this.onChanged,
    super.key,
    this.labelText,
    this.hintText,
    this.errorText,
    this.isPasswordField = false,
    this.textInputAction = TextInputAction.done,
  });

  final String? labelText;
  final String? hintText;
  final String? errorText;
  final TextInputType keyboardType;
  final bool isPasswordField;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextFormField(
    keyboardType: keyboardType,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
    ),
    textInputAction: textInputAction,
    obscureText: isPasswordField,
    onChanged: onChanged,
  );
}

