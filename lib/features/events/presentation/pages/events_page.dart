import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/category_badges.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/events_area.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/search_event.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SearchEvent(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: CategoryBadges(
              categories: ['Música', 'Teatro', 'Cinema', 'Esportes'],
              onTap: (category) {
                // Handle category tap
              },
            ),
          ),
          Expanded(
            child: EventsArea(),
          ),
        ],
      ),
    );
  }
}
