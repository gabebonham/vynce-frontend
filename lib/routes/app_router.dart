import 'package:go_router/go_router.dart';
import 'package:vynce_frontend/features/events/presentation/pages/event_page.dart';
import 'package:vynce_frontend/features/events/presentation/pages/events_page.dart';

final appRouter = GoRouter(
  initialLocation: '/events',
  routes: [
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventsPage(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return EventPage(id: id);
          },
        ),
      ],
    ),
  ],
);