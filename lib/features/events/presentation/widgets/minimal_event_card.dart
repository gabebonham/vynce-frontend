import 'package:flutter/material.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class MinimalEventCard extends StatefulWidget {
  const MinimalEventCard({super.key, required this.event});
  final EventModel event;

  @override
  State<MinimalEventCard> createState() => _MinimalEventCardState(event);
}

class _MinimalEventCardState extends State<MinimalEventCard> {
  bool isFavorite = false;
  final EventModel event;
  _MinimalEventCardState(this.event);
  @override
  Widget build(BuildContext context) {
    final formatted = DateFormat(
      'dd/MM/yyyy • HH:mm',
    ).format(event.date.toLocal());

    return SizedBox(
      width: double.infinity,
      height: 170,
      child: InkWell(
        onTap: () => context.push('/events/${event.id}'),
        borderRadius: BorderRadius.circular(20),
        child: Card(
          shadowColor: Theme.of(context).colorScheme.onSurface,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.08),
              width: 0.5,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: Image.network(
                  'https://picsum.photos/300',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
