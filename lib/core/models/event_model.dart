import 'package:vynce_frontend/core/models/host_model.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';

class EventModel {
  final String id;

  final String title;

  final String description;

  final String imageUrl;

  final String location;
  final String city;

  final String fullLocation;

  final String category;

  final String color;

  final DateTime date;

  final int participantsCount;
  final int maxParticipants;

  final HostModel? host;
  final int? price;
  final double lat;
  final double lng;
  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.city,
    required this.category,
    required this.fullLocation,
    required this.color,
    required this.date,
    required this.participantsCount,
    required this.maxParticipants,
    required this.host,
    required this.price,
    required this.lat,
    required this.lng,
  });
  static List<EventModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => EventModel.fromJson(json)).toList();
  }

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      location: json['location'],
      category: json['category'] ?? '',
      color: json['color'] ?? '0xFF888780',
      date: DateTime.parse(json['date']),
      participantsCount: json['participantsCount'] ?? 0,

      city: json['city'] as String,
      fullLocation: json['fullLocation'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      maxParticipants: json['maxParticipants'] as int,
      price: (json['price'] as num?)?.toInt(),

      host: json['host'] != null
          ? HostModel.fromJson(json['host'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'title': title,
      'price': price,

      'description': description,
      'host': host,
      'imageUrl': imageUrl,
      'fullLocation': fullLocation,
      'location': location,
      'category': category,
      'color': color,
      'maxParticipants': maxParticipants,
      'city': city,
      'lng': lng,
      'lat': lat,
      'date': date.toIso8601String(),

      'participantsCount': participantsCount,
    };
  }

  // event_model.dart
  factory EventModel.fromJsonWithoutHost(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      location: json['location'],
      category: json['category'] ?? '',
      color: json['color'] ?? '0xFF888780',
      date: DateTime.parse(json['date']),
      participantsCount: json['participantsCount'] ?? 0,
      city: json['city'] as String,
      fullLocation: json['fullLocation'] as String,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      maxParticipants: json['maxParticipants'] as int,
      price: (json['price'] as num?)?.toInt(),
      host: null,
    );
  }
}
