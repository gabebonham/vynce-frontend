class ProfileModel {
  final String id;

  final String name;

  final String email;

  final String avatarUrl;

  final String location;

  final DateTime createdAt;

  final List<String> favoriteEvents;

  ProfileModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.location,
    required this.createdAt,
    required this.favoriteEvents,
  });
  static List<ProfileModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ProfileModel.fromJson(json)).toList();
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
      location: json['location'],
      favoriteEvents: List<String>.from(json['favoriteEvents']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'name': name,

      'email': email,
      
      'location': location,

      'avatarUrl': avatarUrl,

      'createdAt': createdAt.toIso8601String(),

      'favoriteEvents': favoriteEvents,
    };
  }
}
