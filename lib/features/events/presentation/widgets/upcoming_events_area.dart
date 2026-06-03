import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/models/profile_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:vynce_frontend/features/events/data/services/profile_service.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/upcoming_event_card.dart';

class UpcomingEventsArea extends StatefulWidget {
  const UpcomingEventsArea({super.key});

  @override
  State<UpcomingEventsArea> createState() => _UpcomingEventsAreaState();
}

class _UpcomingEventsAreaState extends State<UpcomingEventsArea> {
  final EventsService _eventsService = getIt<EventsService>();
  final ProfileService _profileService = getIt<ProfileService>();

  List<EventModel> events = [];
  ProfileModel? profile;
  @override
  void initState() {
    super.initState();
    loadEvents();
    loadProfile();
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

  Future<bool> onFavTap(String eventId) async {
    if (profile == null) return false;

    final result = await _eventsService.favoriteEvent(eventId);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EVENTOS CHEGANDO',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight(600),
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        SizedBox(height: 12),
        Column(
          spacing: 14,
          children: events
              .map(
                (e) => UpcomingEventCard(
                  event: e,
                  profile: profile,
                  onFavTap: onFavTap,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
