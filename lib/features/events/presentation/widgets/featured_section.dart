import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/models/event_model.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/event_card.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({
    super.key,
    required this.profile,
    required this.events,
  });

  final ProfileModel profile;
  final List<EventModel> events;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EM DESTAQUE',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 308, // ajusta pra altura real do EventCard
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: events
                    .map(
                      (e) => EventCard(
                        event: e,
                        profile: profile,
                        onFavTap: (String eventId) {},
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
