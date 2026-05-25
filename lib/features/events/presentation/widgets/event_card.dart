import 'package:flutter/material.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/avatar_stack.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class EventCard extends StatefulWidget {
  const EventCard({super.key, required this.event});

  final EventModel event;

  @override
  State<EventCard> createState() => _EventCardState(event);
}

class _EventCardState extends State<EventCard> {
  bool isFavorite = false;
  final EventModel event;
  _EventCardState(this.event);

  @override
  Widget build(BuildContext context) {
    final date = widget.event.date.toLocal();
    final formatted = DateFormat('dd/MM/yyyy • HH:mm').format(date);
    return InkWell(
      onTap: () => context.go('/events/${event.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),

          side: BorderSide(color: Colors.black.withOpacity(0.1), width: 2),
        ),
        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
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
                            widget.event.title,
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
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Theme.of(context).primaryColor,
                            ),
                            Text(
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                              widget.event.location,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isFavorite = !isFavorite;
                          });
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      Badge(
                        label: Text('doideira'),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      Badge(
                        label: Text('daora'),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      Badge(
                        label: Text('festa'),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      Badge(
                        label: Text('caramba!'),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                          widget.event.description,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
              child: AvatarStack(totalCount: widget.event.participantsCount),
            ),
          ],
        ),
      ),
    );
  }
}
