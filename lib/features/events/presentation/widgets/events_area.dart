import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/event_card.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/featured_section.dart';
import 'package:vynce_frontend/features/events/presentation/widgets/next_to_you_area.dart';

class EventsArea extends StatefulWidget {
  @override
  State<EventsArea> createState() => _EventsAreaState();
}

class _EventsAreaState extends State<EventsArea> {


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FeaturedSection(),
        NextToYouArea()
      ],
    );
  }
}
