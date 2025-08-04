import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/index.dart';
import 'resources/generated/l10n.dart';

class App extends StatefulWidget {
  const App({required this.appFlavor, super.key});

  final AppFlavor appFlavor;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver, AppLifecycleMixin {
  final _appLifecycle = injector.read(appLifecycleProvider);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _appLifecycle.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _appLifecycle.addAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) => Consumer(
    builder: (context, ref, child) => MaterialApp.router(
      routerConfig: goRouter,
      locale: localeProvider.listen(ref, (locale) => locale),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: SupportLocale.support,
      theme: ThemeData(
        brightness: themeProvider.listen(ref, (theme) => theme),
      ),
      builder: (context, widget) => getResponsiveWrapper(context, widget),
    ),
  );
}
