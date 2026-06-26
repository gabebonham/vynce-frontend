import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:vynce_frontend/core/notifiers/auth_notifier.dart';
import 'package:vynce_frontend/features/auth/auth_page.dart';
import 'package:vynce_frontend/features/chat/chat_page.dart';
import 'package:vynce_frontend/features/chats/widgets/chats_page.dart';
import 'package:vynce_frontend/features/events/presentation/pages/event_page.dart';
import 'package:vynce_frontend/features/events/presentation/pages/events_page.dart';
import 'package:vynce_frontend/features/events/presentation/pages/filtered_events_page.dart';
import 'package:vynce_frontend/features/host-profile/host_profile_page.dart';
import 'package:vynce_frontend/features/map/map_page.dart';
import 'package:vynce_frontend/features/match/match_page.dart';
import 'package:vynce_frontend/features/me/me_page.dart';
import 'package:vynce_frontend/features/profile/profile_page.dart';
import 'package:vynce_frontend/navigation/widgets/events_navigation_shell.dart';
import 'package:vynce_frontend/navigation/widgets/main_navigation_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _eventsShellNavigatorKey = GlobalKey<NavigatorState>();
final _mapShellNavigatorKey = GlobalKey<NavigatorState>();
final _chatsShellNavigatorKey = GlobalKey<NavigatorState>();
final _meShellNavigatorKey = GlobalKey<NavigatorState>();
final _eventsFilterShellNavigatorKey = GlobalKey<NavigatorState>();

class _RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  _RouterNotifier(this._ref) {
    _ref.listen(authProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider((ref) {
  final notifier = _RouterNotifier(ref);
  final isAuthenticated = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/events',
    refreshListenable: notifier,
    redirect: (context, state) {
      final isOnAuth = state.matchedLocation.startsWith('/auth');

      if (!isAuthenticated && !isOnAuth) return '/auth';
      if (isAuthenticated && isOnAuth) return '/events';
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (_, __) => '/events'),

      // Auth
      GoRoute(path: '/auth', builder: (_, __) => const AuthPage()),

      // Rotas fora das abas (full screen, sem bottom nav)
      GoRoute(
        path: '/chat/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => ChatPage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/host-profile/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => HostProfilePage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/profile/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, state) => ProfilePage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/match/:eventId',
        builder: (context, state) =>
            MatchPage(eventId: state.pathParameters['eventId']!),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainNavigationBar(navigationShell: navigationShell),
        branches: [
          // Branch 0: Eventos (com sub-shell de filtro)
          StatefulShellBranch(
            navigatorKey: _eventsShellNavigatorKey,
            routes: [
              ShellRoute(
                navigatorKey: _eventsFilterShellNavigatorKey,
                builder: (context, state, child) =>
                    EventsNavigationShell(child: child),
                routes: [
                  GoRoute(
                    path: '/events',
                    builder: (_, __) => const EventsPage(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        parentNavigatorKey: _rootNavigatorKey,
                        builder: (_, state) =>
                            EventPage(id: state.pathParameters['id']!),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: '/events-filtered',
                    builder: (_, __) => const FilteredEventsPage(),
                  ),
                ],
              ),
            ],
          ),

          // Branch 1: Mapa
          StatefulShellBranch(
            navigatorKey: _mapShellNavigatorKey,
            routes: [
              GoRoute(
                path: '/map',
                builder: (_, state) => MapPage(eventId: state.extra as String?),
              ),
            ],
          ),

          // Branch 2: Chats
          StatefulShellBranch(
            navigatorKey: _chatsShellNavigatorKey,
            routes: [
              GoRoute(path: '/chats', builder: (_, state) => ChatsPage()),
            ],
          ),

          // Branch 3: Me
          StatefulShellBranch(
            navigatorKey: _meShellNavigatorKey,
            routes: [GoRoute(path: '/me', builder: (_, state) => MePage())],
          ),
        ],
      ),
    ],
  );
});
