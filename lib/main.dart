import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/core/notifiers/auth_notifier.dart';
import 'package:vynce_frontend/core/theme/app_theme.dart';
import 'package:vynce_frontend/routes/app_router.dart'; // <-- adiciona
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  setupInjector();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    ref.read(authProvider.notifier).init();
    return MaterialApp.router(
      title: 'Vynce',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
