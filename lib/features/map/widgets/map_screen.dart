import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vynce_frontend/core/injector.dart';
import 'package:vynce_frontend/features/map/services/map_service.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapService mapService = getIt<MapService>();
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initLocation() async {
    final latLng = await mapService.getCurrentLocation();

    setState(() {
      _currentPosition = latLng;
      _markers.add(
        Marker(
          markerId: const MarkerId('user'),
          position: latLng,
          infoWindow: const InfoWindow(title: 'Você está aqui'),
        ),
      );
    });

    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentPosition!,
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
              onMapCreated: (controller) => _mapController = controller,
            ),
    );
  }
}
