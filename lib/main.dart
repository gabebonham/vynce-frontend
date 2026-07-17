import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/config/env.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/core/theme/app_theme.dart';
import 'package:vynce_frontend/routes/app_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // sempre primeira linha
  setupInjector();
  await Env.load();
  await initializeDateFormatting('pt_BR');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Vynce',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
