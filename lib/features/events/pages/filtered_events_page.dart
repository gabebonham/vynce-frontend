import 'package:flutter/material.dart';
import 'package:vynce_frontend/features/events/widgets/filtered_section.dart';

class FilteredEventsPage extends StatefulWidget {
  const FilteredEventsPage({super.key});

  @override
  State<FilteredEventsPage> createState() => _FilteredEventsPageState();
}

class _FilteredEventsPageState extends State<FilteredEventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsetsGeometry.fromLTRB(20, 12, 18, 16),
              child: FilteredSection(),
            ),
          ),
        ],
      ),
    );
  }
}
