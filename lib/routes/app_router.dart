import 'package:go_router/go_router.dart';
import 'package:vynce_frontend/features/events/presentation/pages/event_page.dart';
import 'package:vynce_frontend/features/events/presentation/pages/events_page.dart';
import 'package:vynce_frontend/features/events/presentation/pages/filtered_events_page.dart';
import 'package:vynce_frontend/navigation/widgets/events_navigation_shell.dart';
import 'package:vynce_frontend/navigation/widgets/main_navigation_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/events',

  routes: [
    GoRoute(path: '/', redirect: (_, _) => '/events'),

    ShellRoute(
      builder: (context, state, child) => MainNavingationBar(child: child),
      routes: [
        GoRoute(
          path: '/events/:id', // vira /events/:id
          builder: (_, state) => EventPage(id: state.pathParameters['id']!),
        ),
        ShellRoute(
          builder: (context, state, child) =>
              EventsNavigationShell(child: child),
          routes: [
            GoRoute(path: '/events', builder: (_, __) => const EventsPage()),
            GoRoute(
              path: '/events-filtered',
              builder: (_, __) => const FilteredEventsPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
