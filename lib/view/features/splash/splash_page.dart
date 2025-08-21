import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/index.dart';
import 'splash_view_model.dart';

final _provider = StateNotifierProvider.autoDispose((ref) => SplashViewModel());

class SplashPage extends BasePage {
  const SplashPage({super.key});

  @override
  BasePageState<SplashPage, SplashViewModel> createState() =>
      _SplashViewState();
}

class _SplashViewState extends BasePageState<SplashPage, SplashViewModel> {
  @override
  SplashViewModel get viewModel => _provider.viewModel(ref);

  @override
  void onInitState() {
    super.onInitState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final r = LoginRoute(userId: '123', query: 'info');
    //   appRouter.go(r.location);
    // });
  }

  @override
  PreferredSizeWidget? buildAppBar(BuildContext context) => null;

  @override
  Widget buildBody(BuildContext context) => Center(
    child: InkWell(
      onTap: () async {
        final r = LoginRoute(userId: '123', query: 'info');
        final a = await appRouter.push(r.location);
        print(a);
      },
      child: SizedBox(
        height: 100,
        width: 100,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
          child: const Center(child: CircularProgressIndicator.adaptive()),
        ),
      ),
    ),
  );
}
