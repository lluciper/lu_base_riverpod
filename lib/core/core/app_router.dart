import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../view/features/login/login_page.dart';
import '../../view/features/splash/splash_page.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,
  routes: $appRoutes,
);

class RouterPath {
  RouterPath._();
  static const splash = '/';
  static const login = 'login';
  static const home = 'home';
}

@TypedGoRoute<SplashRoute>(
  path: SplashRoute.path,
  routes: [TypedGoRoute<LoginRoute>(path: LoginRoute.path)],
)
class SplashRoute extends GoRouteData with _$SplashRoute {
  const SplashRoute();
  static const path = RouterPath.splash;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SplashPage();
  }
}

class LoginRoute extends GoRouteData with _$LoginRoute {
  const LoginRoute({this.userId, this.query});
  static const path = RouterPath.login;
  final String? userId;
  final String? query;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    print(userId);
    print(query);
    return const LoginPage();
  }
}

// class HomeRoute extends GoRouteData with _$HomeRoute {
//   const HomeRoute({this.userId, this.query});
//   static const path = RoutingConstants.HOME;
//   final String? userId;
//   final String? query;

//   @override
//   Widget build(BuildContext context, GoRouterState state) {
//     print(userId);
//     print(query);
//     return const HomeScreen();
//   }
// }