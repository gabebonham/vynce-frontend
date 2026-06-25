import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vynce_frontend/features/events/data/models/event_filter.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';

class MapScreen extends StatefulWidget {
  final EventFilter filter;
  final List<EventModel> events;
  final LatLng currentPosition;
  final String? focusEventId;

  const MapScreen({
    super.key,
    required this.filter,
    required this.events,
    required this.currentPosition,
    this.focusEventId,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadEventMarkers();
  }

  @override
  void didUpdateWidget(MapScreen oldWidget) {
    print(widget.events.length);
    super.didUpdateWidget(oldWidget);
    if (oldWidget.events != widget.events) {
      _loadEventMarkers();
      if (widget.focusEventId != null) _focusEvent();
    }
  }

  void _focusEvent() {
    print('focusEventId: ${widget.focusEventId}');
    print('event ids: ${widget.events.map((e) => e.id).toList()}');
    final event = widget.events
        .where((e) => e.id == widget.focusEventId)
        .firstOrNull;
    print('found: $event');
    if (event == null) return;
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(event.lat, event.lng), 16),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(widget.currentPosition, 13),
    );
  }

  Future<void> _loadEventMarkers() async {
    final events = widget.events;

    setState(() {
      _markers
        ..clear()
        ..add(
          Marker(
            markerId: const MarkerId('user'),
            position: widget.currentPosition,
            infoWindow: const InfoWindow(title: 'Você está aqui'),
          ),
        );

      for (final event in events) {
        _markers.add(
          Marker(
            markerId: MarkerId(event.id),
            position: LatLng(event.lat, event.lng),
            infoWindow: InfoWindow(title: event.title),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.currentPosition,
        zoom: 15,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: _markers,
      onMapCreated: (controller) {
        _mapController = controller;
        _initLocation();
      },
    );
  }
}
