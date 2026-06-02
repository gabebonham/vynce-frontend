import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/favorites_section.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/featured_section.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/next_to_you_area.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/upcoming_events_area.dart';

class EventsArea extends StatefulWidget {
  @override
  State<EventsArea> createState() => _EventsAreaState();
}

class _EventsAreaState extends State<EventsArea> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FeaturedSection(),
        SizedBox(height: 26),
        NextToYouArea(),
        SizedBox(height: 26),
        FavoritesSection(),
        SizedBox(height: 26),
        UpcomingEventsArea(),
      ],
    );
  }
}
