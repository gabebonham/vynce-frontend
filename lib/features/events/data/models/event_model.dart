class EventModel {
  final String id;

  final String title;

  final String description;

  final String imageUrl;

  final String location;

  final String category;

  final DateTime date;

  final int participantsCount;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.category,
    required this.date,
    required this.participantsCount,
  });
  static List<EventModel> fromJsonList(
    List<dynamic> jsonList,
  ) {
    return jsonList
        .map(
          (json) =>
              EventModel.fromJson(json),
        )
        .toList();
  }
  factory EventModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return EventModel(
      id: json['id'],

      title: json['title'],

      description:
          json['description'],

      imageUrl: json['image_url'],

      location: json['location'],
      category: json['category'],

      date: DateTime.parse(
        json['date'],
      ),

      participantsCount:
          json['participants_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'title': title,

      'description': description,

      'image_url': imageUrl,

      'location': location,
      'category': category,

      'date': date.toIso8601String(),

      'participants_count':
          participantsCount,
    };
  }
}