import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/models/profile_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:vynce_frontend/features/events/data/services/profile_service.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/event_card.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/favorite_event_card.dart';

class FavoritesSection extends StatefulWidget {
  const FavoritesSection({super.key});
  @override
  State<FavoritesSection> createState() => _FavoritesSectionState();
}

class _FavoritesSectionState extends State<FavoritesSection> {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SEUS FAVORITOS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight(600),
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: events
                  .map(
                    (e) => FavoriteEventCard(
                      event: e,
                      profile: profile,
                      onFavTap: (eventId) async {
                        // Handle favorite tap logic here
                        return true;
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
