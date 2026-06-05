import 'package:vynce_frontend/features/events/data/models/profile_model.dart';

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

  final ProfileModel host;
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
      host: ProfileModel.fromJson(json['host']),
      description: json['description'],

      fullLocation: json['fullLocation'],
      city: json['city'],

      imageUrl: json['imageUrl'],
      maxParticipants: json['maxParticipants'],
      price: json['price'],

      location: json['location'],
      category: json['category'],
      color: json['color'],

      date: DateTime.parse(json['date']),
      lat: json['lat'],
      lng: json['lng'],
      participantsCount: json['participantsCount'],
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
}
