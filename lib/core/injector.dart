import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../features/events/data/services/event_service.dart';

final getIt = GetIt.instance;

void setupInjector() {
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'https://api.seusite.com',
      ),
    ),
  );

  getIt.registerLazySingleton<EventsService>(
    () => EventsService(getIt<Dio>()),
  );
}