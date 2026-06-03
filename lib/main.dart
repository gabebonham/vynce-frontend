import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/core/theme/app_theme.dart';
import 'package:vynce_frontend/routes/app_router.dart'; // <-- adiciona
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  setupInjector();
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Vynce',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
