import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/event_card.dart';

class EventsArea extends StatefulWidget {
  @override
  State<EventsArea> createState() => _EventsAreaState();
}
class _EventsAreaState extends State<EventsArea> {
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
    return ListView(
      padding: EdgeInsets.all(12),
      children: events.map((e) => EventCard(event: e)).toList(),
    );
  }
}