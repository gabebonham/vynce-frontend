import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/events/data/models/event_filter.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/services/event_service.dart';
import 'package:vynce_frontend/features/map/services/map_service.dart';

class MapScreen extends StatefulWidget {
  final EventFilter filter;
  final List<EventModel> events;
  final LatLng currentPosition;

  const MapScreen({
    super.key,
    required this.filter,
    required this.events,
    required this.currentPosition,
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
    _initLocation();
  }

  @override
  void didUpdateWidget(MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter != widget.filter) {
      _loadEventMarkers();
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    final latLng = widget.currentPosition;
    await _loadEventMarkers();
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 13));
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
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(widget.currentPosition, 13),
        );
      },
    );
  }
}
