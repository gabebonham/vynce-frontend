import 'package:go_router/go_router.dart';
import 'package:vynce_frontend/features/events/presentation/pages/event_page.dart';
import 'package:vynce_frontend/features/events/presentation/pages/events_page.dart';
import 'package:vynce_frontend/navigation/widgets/main_navigation_bar.dart';

final appRouter = GoRouter(
  initialLocation: '/events',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainNavingationBar(child: child),
      routes: [
        GoRoute(path: '/events', builder: (_, __) => const EventsPage()),
        // GoRoute(path: '/map', builder: (_, __) => const MapPage()),
        // GoRoute(path: '/chat', builder: (_, __) => const ChatPage()),
        // GoRoute(path: '/profile', builder: (_, __) => const ProfilePage()),
      ],
    ),
    // GoRoute(path: '/events/new', builder: (_, __) => const NewEventPage()),
    GoRoute(path: '/events/:id', builder: (_, state) => EventPage(id: state.pathParameters['id']!)),
  ],
);