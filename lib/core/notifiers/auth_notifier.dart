import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vynce_frontend/core/services/storage_service.dart';

final authProvider = NotifierProvider<AuthNotifier, bool>(() => AuthNotifier());

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  Future<void> init() async {
    final token = await Storage.getToken();
    state = token != null;
  }

  Future<void> login(String token) async {
    await Storage.saveToken(token);
    state = true;
  }

  Future<void> logout() async {
    await Storage.deleteToken();
    state = false;
  }
}
