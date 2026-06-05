import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vynce_frontend/features/map/models/place_result_model.dart';

class MapService {
  Future<LatLng> getCurrentLocation() async {
    await Future.delayed(const Duration(milliseconds: 500)); // simula latência
    return const LatLng(-30.0346, -51.2177); // Porto Alegre
  }

  Future<List<PlaceResult>> searchPlaces(String query) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      PlaceResult(
        name: 'Lugar Mockado 1',
        position: const LatLng(-30.032, -51.230),
      ),
      PlaceResult(
        name: 'Lugar Mockado 2',
        position: const LatLng(-30.028, -51.218),
      ),
    ];
  }

  Future<String> reverseGeocode(LatLng position) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return 'Rua Mockada, 123 - Porto Alegre';
  }
}
