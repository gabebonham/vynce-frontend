import 'package:dio/dio.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vynce_frontend/features/map/models/place_result_model.dart';

class MapService {
  final Dio dio;

  MapService(this.dio);
  Future<LatLng> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('GPS desativado');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        throw Exception('Permissão negada');
    }

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return LatLng(pos.latitude, pos.longitude);
  }

  Future<List<PlaceResult>> searchPlaces(String query) async {
    final response = await dio.get(
      'https://maps.googleapis.com/maps/api/place/textsearch/json',
      queryParameters: {
        'query': query,
        'key': const String.fromEnvironment('MAPS_API_KEY'),
        'language': 'pt-BR',
      },
    );

    final results = response.data['results'] as List;

    return results.map((place) {
      final loc = place['geometry']['location'];
      return PlaceResult(
        name: place['name'],
        position: LatLng(loc['lat'], loc['lng']),
      );
    }).toList();
  }

  Future<String> reverseGeocode(LatLng position) async {
    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final place = placemarks.first;
    return '${place.street}, ${place.subLocality} - ${place.locality}';
  }
}
