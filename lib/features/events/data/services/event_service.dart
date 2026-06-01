import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:vynce_frontend/features/events/data/models/event_model.dart';

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

    return events[0];
  }

  Future<bool> favoriteEvent(String profileId, String id) async {
    return Future(() => true);
  }
}
