import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_filter.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/models/profile_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:vynce_frontend/features/events/data/services/profile_service.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/minimal_event_card.dart';

class FilteredSection extends StatefulWidget {
  const FilteredSection({super.key});
  @override
  State<FilteredSection> createState() => _FilteredSectionState();
}

class _FilteredSectionState extends State<FilteredSection> {
  final EventsService _eventsService = getIt<EventsService>();
  final ProfileService _profileService = getIt<ProfileService>();
  List<EventModel> events = [];
  ProfileModel? profile;
  EventFilter? currentFilter;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentFilter = getFilters(context);
      loadEventsFiltered();
      loadProfile();
    });
  }

  Future<void> loadEventsFiltered() async {
    final result = await _eventsService.getEventsFiltered(currentFilter!);

    setState(() {
      events = result;
    });
  }

  EventFilter getFilters(BuildContext context) {
    final category = GoRouterState.of(context).uri.queryParameters['category'];
    final minParticipants = int.tryParse(
      GoRouterState.of(context).uri.queryParameters['minParticipants'] ?? '0',
    );
    final maxDistanceKm = double.tryParse(
      GoRouterState.of(context).uri.queryParameters['maxDistanceKm'] ?? '100',
    );
    final dateRange = GoRouterState.of(
      context,
    ).uri.queryParameters['dateRange'];
    final onlyFavorites = bool.tryParse(
      GoRouterState.of(context).uri.queryParameters['onlyFavorites'] ?? 'false',
    );
    return EventFilter(
      category: category,
      minParticipants: minParticipants ?? 0,
      maxDistanceKm: maxDistanceKm ?? 100,
      dateRange: dateRange,
      onlyFavorites: onlyFavorites ?? false,
    );
  }

  Future<void> loadProfile() async {
    final result = await _profileService.getProfile('1');

    setState(() {
      profile = result;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadEvents() async {
    final result = await _eventsService.getEvents();

    setState(() {
      events = result;
    });
  }

  // filtered_section.dart
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => MinimalEventCard(
              event: events[i],
              profile: profile,
              onFavTap: (eventId) async => true,
            ),
          ),
        ),
      ],
    );
  }
}
