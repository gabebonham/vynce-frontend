import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/minimal_event_card.dart';

class NextToYouArea extends StatefulWidget {
  const NextToYouArea({super.key});

  @override
  State<NextToYouArea> createState() => _NextToYouAreaState();
}

class _NextToYouAreaState extends State<NextToYouArea> {
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
        SizedBox(height: 4),
        Column(
          children: events.map((e) => MinimalEventCard(event: e)).toList(),
        ),
      ],
    );
  }
}
