import 'package:flutter/material.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';

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
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),

        side: BorderSide(
          color: Colors.black.withOpacity(0.1),
          width: 2,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),

        child: Column(
          spacing: 4,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: double.infinity,
                height: 220,

                child: Image.network(
                  'https://picsum.photos/300',

                  fit: BoxFit.cover,
                ),
              ),

            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    widget.event.title,
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
                Badge(label: Text('doideira'), backgroundColor: Theme.of(context).primaryColor),
                Badge(label: Text('daora'), backgroundColor: Theme.of(context).primaryColor),
                Badge(label: Text('festa'), backgroundColor: Theme.of(context).primaryColor),
                Badge(label: Text('caramba!'), backgroundColor: Theme.of(context).primaryColor),
              ],
            ),
            SizedBox(width: 8),
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
    );
  }
}
