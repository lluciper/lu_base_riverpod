import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/services.dart';
import 'auth_repository.dart';
import 'home_repository.dart';

part 'repository.g.dart';

@riverpod
Repository repository(Ref ref) => throw UnimplementedError();

class Repository {
  Repository(Services services) {
    auth = AuthRepository(services);
    home = HomeRepository(services);
  }

  late AuthRepository auth;

  late HomeRepository home;
}
