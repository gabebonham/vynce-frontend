import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_filter.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:vynce_frontend/features/map/services/map_service.dart';
import 'package:vynce_frontend/features/map/widgets/filter_sheet.dart';
import 'package:vynce_frontend/features/map/widgets/map_screen.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  EventFilter _filter = EventFilter();
  MapService mapService = getIt<MapService>();
  EventsService eventsService = getIt<EventsService>();
  LatLng? _currentPosition;
  List<EventModel> _events = [];
  int get _activeFilterCount {
    int count = 0;
    if (_filter.category != null) count++;
    if (_filter.onlyFavorites) count++;
    if (_filter.maxDistanceKm != 100) count++;
    if (_filter.minParticipants != 0) count++;
    return count;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final position = await mapService.getCurrentLocation();
    final events = await eventsService.getNearbyEvents(
      position,
      filter: _filter,
    );
    setState(() {
      _currentPosition = position;
      _events = events;
    });
  }

  Future<void> loadEvents() async {
    _events = await eventsService.getNearbyEvents(
      _currentPosition!,
      filter: _filter,
    );
  }

  Future<void> loadCurrentLocation() async {
    _currentPosition = await mapService.getCurrentLocation();
  }

  Future<void> onApplyFilters(EventFilter filter) async {
    final events = await eventsService.getNearbyEvents(
      _currentPosition!,
      filter: filter,
    );
    setState(() {
      _filter = filter;
      _events = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : MapScreen(
                  filter: _filter,
                  currentPosition: _currentPosition!,
                  events: _events,
                ),
          Positioned(
            top: 48,
            right: 16,
            child: _FilterFab(
              activeCount: _activeFilterCount,
              onTap: () => _openFilterSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  void _openFilterSheet(BuildContext context) async {
    final result = await showModalBottomSheet<EventFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) =>
          FilterSheet(initialFilter: _filter, onApply: onApplyFilters),
    );
    if (result != null) setState(() => _filter = result);
  }
}

class _FilterFab extends StatelessWidget {
  final int activeCount;
  final VoidCallback onTap;

  const _FilterFab({required this.activeCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: const Icon(Icons.tune),
          ),
          if (activeCount > 0)
            Positioned(
              top: -6,
              right: -6,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  color: Colors.pink,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$activeCount',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
