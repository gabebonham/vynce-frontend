import 'package:flutter/material.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/events_area.dart';

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
          Expanded(
            child: Padding(
              padding: EdgeInsetsGeometry.fromLTRB(20, 12, 18, 16),
              child: EventsArea(),
            ),
          ),
        ],
      ),
    );
  }
}
