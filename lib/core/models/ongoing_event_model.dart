import 'package:flutter/rendering.dart';
import 'package:vynce_frontend/core/models/host_model.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';

class OngoingEventModel {
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
  final List<ProfileModel> checkedInParticipants;
  final HostModel? host;
  final int? price;
  final double lat;
  final double lng;
  OngoingEventModel({
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
    required this.checkedInParticipants,
    required this.host,
    required this.price,
    required this.lat,
    required this.lng,
  });
  static List<OngoingEventModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => OngoingEventModel.fromJson(json)).toList();
  }

  factory OngoingEventModel.fromJson(Map<String, dynamic> json) {
    try {
      return OngoingEventModel(
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
        checkedInParticipants: json['checkedInParticipants'] != null
            ? ProfileModel.fromJsonList(
                json['checkedInParticipants'] as List<dynamic>,
              )
            : [],
      );
    } catch (e) {
      debugPrint('ERRO no OngoingEventModel.fromJson: $e');
      debugPrint('json: $json');
      rethrow;
    }
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
      'checkedInParticipants': checkedInParticipants,
      'participantsCount': participantsCount,
    };
  }
}
