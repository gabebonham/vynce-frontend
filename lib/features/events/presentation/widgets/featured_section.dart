import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/event_card.dart';

class FeaturedSection extends StatefulWidget {
  const FeaturedSection({super.key});
  @override
  State<FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<FeaturedSection> {
  final EventsService _eventsService = getIt<EventsService>();
  List<EventModel> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
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
      padding: EdgeInsets.fromLTRB(0, 0, 0, 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EM DESTAQUE',
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
              children: events.map((e) => EventCard(event: e)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
