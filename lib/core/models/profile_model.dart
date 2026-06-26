import 'package:flutter/rendering.dart';
import 'package:vynce_frontend/core/models/event_model.dart';

class ProfileModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String? bannerUrl; // <- novo, nullable
  final String location;
  final String? bio; // <- novo, nullable
  final int pendingMatches;
  final int followersCount; // <- novo
  final int followingCount; // <- novo
  final List<String> favoriteEvents;
  final List<EventModel> events; // <- novo
  final double? rating;
  final DateTime createdAt;
  final int age;
  final List<String> interests;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.bannerUrl,
    required this.location,
    this.bio,
    required this.pendingMatches,
    this.followersCount = 0,
    this.followingCount = 0,
    required this.favoriteEvents,
    this.events = const [],
    this.rating,
    required this.createdAt,
    required this.age,
    required this.interests,
  });

  static List<ProfileModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) {
      try {
        return ProfileModel.fromJson(json);
      } catch (e) {
        debugPrint('ERRO no ProfileModel.fromJson: $e');
        debugPrint('json problemático: $json');
        rethrow;
      }
    }).toList();
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      bannerUrl: json['bannerUrl'] as String?,
      location: json['location'],
      bio: json['bio'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      pendingMatches: json['pendingMatches'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      favoriteEvents: List<String>.from(json['favoriteEvents'] ?? []),
      events:
          (json['events'] as List<dynamic>?)
              ?.map((e) => EventModel.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      age: (json['age'] as int?) ?? 0,
      interests: List<String>.from(json['interests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'bannerUrl': bannerUrl,
      'location': location,
      'bio': bio,
      'rating': rating,
      'pendingMatches': pendingMatches,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'favoriteEvents': favoriteEvents,
      'events': events.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'age': age,
      'interests': interests,
    };
  }
}
