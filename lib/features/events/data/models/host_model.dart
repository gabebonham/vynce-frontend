import 'package:vynce_frontend/features/events/data/models/event_model.dart';

class HostModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final String? bannerUrl;
  final String location;
  final String? bio;
  final double? rating;
  final int followersCount;
  final int followingCount;
  final int pendingMatches;
  final List<String> favoriteEvents;
  final List<EventModel> events;
  final DateTime createdAt;

  HostModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    this.bannerUrl,
    required this.location,
    this.bio,
    this.rating,
    this.followersCount = 0,
    this.followingCount = 0,
    required this.pendingMatches,
    required this.favoriteEvents,
    this.events = const [],
    required this.createdAt,
  });

  static List<HostModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => HostModel.fromJson(json)).toList();
  }

  factory HostModel.fromJson(Map<String, dynamic> json) {
    return HostModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      bannerUrl: json['bannerUrl'] as String?,
      location: json['location'],
      bio: json['bio'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      pendingMatches: json['pendingMatches'] ?? 0,
      favoriteEvents: List<String>.from(json['favoriteEvents'] ?? []),
      events:
          (json['events'] as List<dynamic>?)
              ?.map(
                (e) =>
                    EventModel.fromJsonWithoutHost(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
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
      'followersCount': followersCount,
      'followingCount': followingCount,
      'pendingMatches': pendingMatches,
      'favoriteEvents': favoriteEvents,
      'events': events.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
