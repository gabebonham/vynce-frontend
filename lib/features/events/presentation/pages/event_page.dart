import 'package:flutter/material.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:intl/intl.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key, required this.id});
  final String id;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final EventsService _eventsService = getIt<EventsService>();
  EventModel? event;

  @override
  void initState() {
    super.initState();
    loadEvent();
  }
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadEvent() async {
    final result = await _eventsService.getEvent(widget.id);

    setState(() {
      event = result;
    });
  }
  @override
  Widget build(BuildContext context) {
  final date = event?.date.toLocal();
  final formatted = date != null
      ? DateFormat('dd/MM/yyyy • HH:mm').format(date)
      : '';
    return Scaffold(
      body: Column(
        children: [
          ClipRRect(

            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 220,
                  child: Image.network(
                    'https://picsum.photos/300',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatted,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          event?.title ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
