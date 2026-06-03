class ProfileModel {
  final String id;

  final String name;

  final int pendingMatches;

  final String email;

  final String avatarUrl;

  final String location;

  final DateTime createdAt;

  final List<String> favoriteEvents;
  double? rating;
  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.location,
    required this.createdAt,
    required this.favoriteEvents,
    required this.pendingMatches,
    this.rating,
  });
  static List<ProfileModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ProfileModel.fromJson(json)).toList();
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      rating: (json['rating'] as num?)?.toDouble(),
      avatarUrl: json['avatarUrl'],
      location: json['location'],
      favoriteEvents: List<String>.from(json['favoriteEvents']),
      pendingMatches: json['pendingMatches'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'name': name,

      'email': email,

      'location': location,
      'rating': rating,
      'avatarUrl': avatarUrl,

      'pendingMatches': pendingMatches,

      'createdAt': createdAt.toIso8601String(),

      'favoriteEvents': favoriteEvents,
    };
  }
}
