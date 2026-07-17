import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/core/models/event_model.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';
import 'package:vynce_frontend/core/services/event_service.dart';
import 'package:vynce_frontend/core/services/profile_service.dart';
import 'package:vynce_frontend/features/events/widgets/upcoming_event_card.dart';

class UpcomingEventsArea extends StatefulWidget {
  const UpcomingEventsArea({
    super.key,
    required this.profile,
    required this.events,
    required this.onFavTap,
  });
  final ProfileModel profile;
  final List<EventModel> events;
  final Function(String) onFavTap;
  @override
  State<UpcomingEventsArea> createState() => _UpcomingEventsAreaState();
}

class _UpcomingEventsAreaState extends State<UpcomingEventsArea> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          children: widget.events
              .map(
                (e) => UpcomingEventCard(
                  event: e,
                  profile: widget.profile,
                  onFavTap: widget.onFavTap,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
