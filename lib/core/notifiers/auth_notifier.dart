import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vynce_frontend/core/services/storage_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

final authProvider = NotifierProvider<AuthNotifier, AuthStatus>(
  () => AuthNotifier(),
);

class AuthNotifier extends Notifier<AuthStatus> {
  @override
  AuthStatus build() {
    _init();
    return AuthStatus.unknown;
  }

  Future<void> _init() async {
    final token = await Storage.getToken();
    state = token != null
        ? AuthStatus.authenticated
        : AuthStatus.unauthenticated;
  }

  Future<void> login(String token) async {
    await Storage.saveToken(token);
    state = AuthStatus.authenticated;
  }

  Future<void> logout() async {
    await Storage.deleteToken();
    state = AuthStatus.unauthenticated;
  }
}
