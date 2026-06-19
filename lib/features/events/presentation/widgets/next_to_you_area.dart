import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/models/profile_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:vynce_frontend/features/events/data/services/profile_service.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/minimal_event_card.dart';

class NextToYouArea extends StatefulWidget {
  const NextToYouArea({
    super.key,
    required this.profile,
    required this.events,
    required this.onFavTap,
  });
  final ProfileModel profile;
  final List<EventModel> events;
  final Function(String) onFavTap;
  @override
  State<NextToYouArea> createState() => _NextToYouAreaState();
}

class _NextToYouAreaState extends State<NextToYouArea> {
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
          'EVENTOS PERTOS DE VOCÊ',
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
                (e) => MinimalEventCard(
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
