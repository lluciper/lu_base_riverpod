import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../view/features/login/login_page.dart';
import '../../view/features/splash/splash_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class RouterPath {
  RouterPath._();

  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
}

/// The route configuration.
final GoRouter goRouter = GoRouter(
  navigatorKey: navigatorKey,
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => SplashPage(),
      routes: <RouteBase>[
        GoRoute(
          path: RouterPath.login,
          builder: (context, state) => LoginPage(),
        ),
        // GoRoute(
        //   path: RouterPath.signUp,
        //   builder: (context, state) => const SignUpPage(),
        // ),
        // GoRoute(
        //   path: RouterPath.verifyAuthCode,
        //   builder: (context, state) => const VerifyAuthCodePage(),
        // ),
        // GoRoute(
        //   path: RouterPath.home,
        //   builder: (context, state) => const HomePagePage(),
        // ),
      ],
    ),
  ],
);

class GoRouteHelper {
  static void go(BuildContext context, String page) {
    context.go(page);
  }

  static void push(BuildContext context, String page) {
    context.push(page);
  }

  static void replace(BuildContext context, String page) {
    context.replace(page);
  }

  static void pop(BuildContext context) {
    context.pop();
  }
}
