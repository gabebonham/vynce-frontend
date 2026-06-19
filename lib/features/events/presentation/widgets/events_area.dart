import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/models/profile_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:vynce_frontend/features/events/data/services/profile_service.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/favorites_section.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/featured_section.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/next_to_you_area.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/upcoming_events_area.dart';

class EventsArea extends StatefulWidget {
  const EventsArea({super.key});

  @override
  State<EventsArea> createState() => EventsAreaState();
}

class EventsAreaState extends State<EventsArea> {
  final EventsService _eventsService = getIt<EventsService>();
  final ProfileService _profileService = getIt<ProfileService>();

  List<EventModel> featured = [];
  List<EventModel> nextTo = [];
  List<EventModel> favorites = [];
  List<EventModel> upcoming = [];
  ProfileModel? profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    reload();
  }

  Future<void> reload() async {
    await Future.wait([loadEvents(), loadProfile()]);
    if (mounted) setState(() => _loading = false);
  }

  Future<void> loadEvents() async {
    final result = await _eventsService.getEvents();
    if (!mounted) return;
    setState(() {
      featured = result;
      nextTo = result;
      favorites = result;
      upcoming = result;
    });
  }

  Future<void> loadProfile() async {
    final result = await _profileService.getProfile("1");
    if (!mounted) return;
    setState(() {
      profile = result;
    });
  }

  Future<bool> onFavTap(String eventId) async {
    if (profile == null) return false;
    final result = await _eventsService.favoriteEvent(eventId);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: reload,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: FeaturedSection(events: featured, profile: profile!),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 26)),
          SliverToBoxAdapter(
            child: NextToYouArea(
              events: nextTo,
              profile: profile!,
              onFavTap: onFavTap,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 26)),
          SliverToBoxAdapter(
            child: FavoritesSection(
              events: favorites,
              profile: profile!,
              onFavTap: onFavTap,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 26)),
          SliverToBoxAdapter(
            child: UpcomingEventsArea(
              events: upcoming,
              profile: profile!,
              onFavTap: onFavTap,
            ),
          ),
        ],
      ),
    );
  }
}
