import 'package:flutter/material.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/event_card.dart';

class FeaturedSection extends StatefulWidget {
  const FeaturedSection({super.key, required this.events});
  final List<EventModel> events;
  @override
  State<FeaturedSection> createState() => _FeaturedSectionState();
}

class _FeaturedSectionState extends State<FeaturedSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EM DESTAQUE',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight(600), color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
        ),
        SizedBox(height: 2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: widget.events.map((e) => EventCard(event: e)).toList(),
          ),
        ),
      ],
    );
  }
}
