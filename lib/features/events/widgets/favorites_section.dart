import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/core/models/event_model.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';
import 'package:vynce_frontend/core/services/event_service.dart';
import 'package:vynce_frontend/core/services/profile_service.dart';
import 'package:vynce_frontend/features/events/widgets/event_card.dart';
import 'package:vynce_frontend/features/events/widgets/favorite_event_card.dart';

class FavoritesSection extends StatefulWidget {
  const FavoritesSection({
    super.key,
    required this.profile,
    required this.events,
    required this.onFavTap,
  });
  final ProfileModel profile;
  final List<EventModel> events;
  final Function(String) onFavTap;
  @override
  State<FavoritesSection> createState() => _FavoritesSectionState();
}

class _FavoritesSectionState extends State<FavoritesSection> {
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
          const SizedBox(height: 4),
          SizedBox(
            height: 228, // ajusta pra altura real do FavoriteEventCard
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.events
                    .map(
                      (e) => FavoriteEventCard(
                        event: e,
                        profile: widget.profile,
                        onFavTap: widget.onFavTap,
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
