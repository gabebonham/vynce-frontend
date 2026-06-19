import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vynce_frontend/core/utils/distance_utils.dart';
import 'package:vynce_frontend/features/events/data/models/event_filter.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';
import 'package:vynce_frontend/features/events/data/models/profile_model.dart';

class EventsService {
  final Dio dio;

  EventsService(this.dio);

  Future<List<EventModel>> getEvents() async {
    // final response = await dio.get('/events');
    final String response = await rootBundle.loadString(
      'assets/mocks/events_mocks.json',
    );

    final List<dynamic> data = jsonDecode(response);

    final events = EventModel.fromJsonList(data);

    return events;
  }

  Future<EventModel> getEvent(String id) async {
    // final response = await dio.get('/events');
    final String response = await rootBundle.loadString(
      'assets/mocks/events_mocks.json',
    );

    final List<dynamic> data = jsonDecode(response);

    final events = EventModel.fromJsonList(data);

    return events.firstWhere((event) => event.id == id);
  }

  Future<List<EventModel>> getEventsFiltered(EventFilter filter) async {
    // final response = await dio.get('/events');
    final String response = await rootBundle.loadString(
      'assets/mocks/events_mocks.json',
    );

    final List<dynamic> data = jsonDecode(response);

    final events = EventModel.fromJsonList(data);
    final String profileRaw = await rootBundle.loadString(
      'assets/mocks/profile_mock.json',
    );
    final dynamic profileJson = jsonDecode(profileRaw);
    final ProfileModel profile = ProfileModel.fromJson(profileJson);
    return events.where((event) => testFilter(event, filter, profile)).toList();
  }

  bool testFilter(EventModel event, EventFilter filter, ProfileModel profile) {
    if (filter.category != null && event.category != filter.category) {
      return false;
    }
    if (event.participantsCount < filter.minParticipants) {
      return false;
    }
    if (filter.title != null &&
        filter.title!.isNotEmpty &&
        !event.title.toLowerCase().contains(filter.title!.toLowerCase())) {
      return false;
    }
    if (filter.onlyFavorites && !profile.favoriteEvents.contains(event.id)) {
      return false;
    }
    if (!_matchesDateRange(event.date, filter.dateRange)) return false;
    return true;
  }

  bool _matchesDateRange(DateTime eventDate, String? dateRange) {
    if (dateRange == null) return true;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final (DateTime start, DateTime end) = switch (dateRange) {
      'hoje' => (today, today.add(const Duration(days: 1))),
      'semana' => (today, today.add(const Duration(days: 7))),
      'mes' => (today, DateTime(now.year, now.month + 1, now.day)),
      'proximo' => (
        DateTime(now.year, now.month + 1, 1),
        DateTime(now.year, now.month + 2, 1),
      ),
      _ => (today, today.add(const Duration(days: 365))),
    };

    return eventDate.isAfter(start) && eventDate.isBefore(end);
  }

  Future<bool> favoriteEvent(String id) async {
    return Future(() => true);
  }

  Future<List<EventModel>> getNearbyEvents(
    LatLng origin, {
    double radiusKm = 1000,
    EventFilter? filter,
  }) async {
    print('filter.title: ${filter?.title}');
    final String response = await rootBundle.loadString(
      'assets/mocks/events_mocks.json',
    );

    final List data = jsonDecode(response);
    final events = data.map((e) => EventModel.fromJson(e)).toList();

    // carrega profile só se precisar filtrar favoritos
    ProfileModel? profile;
    if (filter?.onlyFavorites == true) {
      final String profileRaw = await rootBundle.loadString(
        'assets/mocks/profile_mock.json',
      );
      profile = ProfileModel.fromJson(jsonDecode(profileRaw));
    }

    return events.where((event) {
      final distance = calculateDistanceKm(
        origin.latitude,
        origin.longitude,
        event.lat,
        event.lng,
      );

      if (distance > (filter?.maxDistanceKm ?? radiusKm)) return false;
      if (filter == null) return true;

      // título: sem early return, vira mais um predicado na chain
      if (filter.title != null &&
          !event.title.toLowerCase().contains(filter.title!.toLowerCase()))
        return false;

      if (filter.category != null && event.category != filter.category)
        return false;
      if (event.participantsCount < filter.minParticipants) return false;
      if (filter.onlyFavorites &&
          !(profile?.favoriteEvents.contains(event.id) ?? false))
        return false;
      if (!_matchesDateRange(event.date, filter.dateRange)) return false;

      return true;
    }).toList();
  }
}
