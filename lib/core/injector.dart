import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:vynce_frontend/core/services/chats_service.dart';
import 'package:vynce_frontend/core/services/host_service.dart';
import 'package:vynce_frontend/core/services/profile_service.dart';
import 'package:vynce_frontend/features/map/services/map_service.dart';

import 'services/event_service.dart';
import 'services/categories_service.dart';

final getIt = GetIt.instance;

void setupInjector() {
  getIt.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: 'http://localhost:3000')),
  );

  getIt.registerLazySingleton<EventsService>(() => EventsService(getIt<Dio>()));
  getIt.registerLazySingleton<HostService>(() => HostService(getIt<Dio>()));
  getIt.registerLazySingleton<MapService>(() => MapService(getIt<Dio>()));
  getIt.registerLazySingleton<ChatsService>(() => ChatsService(getIt<Dio>()));
  getIt.registerLazySingleton<CategoriesService>(
    () => CategoriesService(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ProfileService>(
    () => ProfileService(getIt<Dio>()),
  );
}
