import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/services.dart';
import 'auth/auth_repository.dart';
import 'auth/demo_auth_repository.dart';

/// Overridden in `Dependence.initDependence`.
final repositoryProvider = Provider<Repository>(
  (ref) => throw UnimplementedError('repositoryProvider must be overridden'),
);

/// One field per domain repository (`repository.auth`, …).
class Repository {
  /// [demoLogin]: log in without a backend (development, see DemoAuthRepository).
  Repository(Services services, {bool demoLogin = false})
    : auth = demoLogin
          ? DemoAuthRepository(services)
          : AuthRepository(services);

  final AuthRepository auth;
}
