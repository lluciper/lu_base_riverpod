import '../models/auth/login_request_model.dart';
import '../models/auth/login_response_model.dart';
import '../services/services.dart';

class AuthRepository {
  AuthRepository(this._services);

  final Services _services;

  Future<LoginResponseModel> login(LoginRequestModel loginRequest) =>
      _services.dio.login(loginRequest);
}
