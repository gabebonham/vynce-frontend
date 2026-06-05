import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceResult {
  final String name;
  final LatLng position;

  const PlaceResult({required this.name, required this.position});
}
