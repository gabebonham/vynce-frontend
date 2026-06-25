import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_filter.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/models/profile_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:vynce_frontend/features/events/data/services/profile_service.dart';
import 'package:vynce_frontend/features/map/services/map_service.dart';
import 'package:vynce_frontend/features/map/widgets/filter_sheet.dart';
import 'package:vynce_frontend/features/map/widgets/map_event_card.dart';
import 'package:vynce_frontend/features/map/widgets/map_screen.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key, this.eventId});
  final String? eventId;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  EventFilter _filter = EventFilter();
  MapService mapService = getIt<MapService>();
  ProfileService profileService = getIt<ProfileService>();
  EventsService eventsService = getIt<EventsService>();
  LatLng? _currentPosition;
  ProfileModel? _profile;
  List<EventModel> _events = [];
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  int get _activeFilterCount {
    int count = 0;
    if (_filter.category != null) count++;
    if (_filter.onlyFavorites) count++;
    if (_filter.maxDistanceKm != 100) count++;
    if (_filter.minParticipants != 0) count++;
    return count;
  }

  Timer? _debounce;

  final _sheetController = DraggableScrollableController();
  bool _sheetExpanded = false;

  static const double _peekSize = 0.15;
  static const double _expandedSize = 0.55;

  void _toggleSheet() {
    final target = _sheetExpanded ? _peekSize : _expandedSize;
    _sheetController.animateTo(
      target,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
    setState(() => _sheetExpanded = !_sheetExpanded);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(MapPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.eventId != widget.eventId) {
      _init();
    }
  }

  Future<void> _init() async {
    final position = await mapService.getCurrentLocation();

    final filterSemId = _filter.copyWith(id: null);
    final results = await Future.wait([
      eventsService.getNearbyEvents(position, filter: filterSemId),
      profileService.getProfile('1'),
      if (widget.eventId != null) eventsService.getEvent(widget.eventId!),
    ]);

    final nearbyEvents = results[0] as List<EventModel>;
    final focusEvent = widget.eventId != null ? results[2] as EventModel : null;

    final allEvents = [
      if (focusEvent != null) focusEvent,
      ...nearbyEvents.where((e) => e.id != focusEvent?.id),
    ];

    setState(() {
      _currentPosition = position;
      _events = allEvents;
      _profile = results[1] as ProfileModel;
      _filter = filterSemId;
    });
  }

  Future<void> _initEventId() async {
    final position = await mapService.getCurrentLocation();

    final results = await Future.wait([
      eventsService.getEvent(widget.eventId!),
      profileService.getProfile('1'),
    ]);

    setState(() {
      _currentPosition = position;
      _events = [results[0] as EventModel];
      _profile = results[1] as ProfileModel;
      _filter = _filter.copyWith(id: widget.eventId);
    });
  }

  Future<void> loadProfile() async {
    _profile = await profileService.getProfile('1');
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
                  focusEventId: widget.eventId,
                ),
          _searchBar(),
          _eventsSheet(),
        ],
      ),
    );
  }

  Widget _eventsSheet() {
    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: _peekSize,
      minChildSize: _peekSize,
      maxChildSize: _expandedSize,
      snap: true,
      snapSizes: const [_peekSize, _expandedSize],
      builder: (context, scrollController) {
        return ClipRect(
          // garante que nada vaza pra fora do sheet
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: scrollController,
                child: SizedBox(
                  height: 350,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      top: 42, // espaço pro label
                    ),
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      if (_profile == null) return const SizedBox.shrink();
                      return SizedBox(
                        width: 280,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: MapEventCard(
                            event: event,
                            profile: _profile!,
                            onFavTap: (value) {},
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 16,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  child: Text(
                    'EVENTOS PRÓXIMOS A VOCÊ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _searchBar() {
    return Positioned(
      top: 48,
      left: 16,
      right: 16,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    _events = [];
                  });
                  _debounce?.cancel();
                  _debounce = Timer(
                    const Duration(milliseconds: 400),
                    () async {
                      final newFilter = _filter.copyWith(
                        title: value.isEmpty ? null : value,
                      );
                      final events = await eventsService.getNearbyEvents(
                        _currentPosition!,
                        filter: newFilter,
                      );
                      setState(() {
                        _filter = newFilter; // <- faltava isso
                        _events = events;
                      });
                    },
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Buscar eventos...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            final newFilter = _filter.copyWith(title: null);
                            setState(() => _searchQuery = '');
                            eventsService
                                .getNearbyEvents(
                                  _currentPosition!,
                                  filter: newFilter,
                                )
                                .then(
                                  (events) => setState(() {
                                    _filter = newFilter;
                                    _events = events;
                                  }),
                                );
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _FilterFab(
            activeCount: _activeFilterCount,
            onTap: () => _openFilterSheet(context),
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
