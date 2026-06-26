import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/core/models/event_filter.dart';
import 'package:vynce_frontend/core/models/event_model.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';
import 'package:vynce_frontend/core/services/event_service.dart';
import 'package:vynce_frontend/core/services/profile_service.dart';
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

  void _onSearchChanged(String value) {
    final uri = GoRouterState.of(context).uri;
    final newParams = Map<String, String>.from(uri.queryParameters);
    if (value.isEmpty) {
      newParams.remove('title'); // era 'name'
    } else {
      newParams['title'] = value; // era 'name'
    }
    context.go(uri.replace(queryParameters: newParams).toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    currentFilter = getFilters(context);
    loadEventsFiltered();
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

    final title = GoRouterState.of(context).uri.queryParameters['title'];

    return EventFilter(
      category: category,
      title: title,
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
