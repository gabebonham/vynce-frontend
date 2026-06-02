import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:vynce_frontend/features/events/data/services/profile_service.dart';

import '../features/events/data/services/event_service.dart';
import '../features/events/data/services/categories_service.dart';

final getIt = GetIt.instance;

void setupInjector() {
  getIt.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: 'https://api.seusite.com')),
  );

  getIt.registerLazySingleton<EventsService>(() => EventsService(getIt<Dio>()));
  getIt.registerLazySingleton<CategoriesService>(
    () => CategoriesService(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ProfileService>(
    () => ProfileService(getIt<Dio>()),
  );
}
