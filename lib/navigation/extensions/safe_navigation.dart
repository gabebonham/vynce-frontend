import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

extension SafeNavigation on BuildContext {
  static bool _isNavigating = false;

  Future<void> pushSafe(String location) async {
    if (SafeNavigation._isNavigating) return;
    SafeNavigation._isNavigating = true;
    await push(location);
    SafeNavigation._isNavigating = false;
  }
}
