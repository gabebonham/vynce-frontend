import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  const EventCard({super.key});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Text(
              'Nome do Evento',
            ),

            SizedBox(height: 8),

            Text(
              'Descrição do evento',
            ),
          ],
        ),
      ),
    );
  }
}