class EventModel {
  final String id;

  final String title;

  final String description;

  final String imageUrl;

  final String location;

  final String category;

  final String borderColor;

  final DateTime date;

  final int participantsCount;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.category,
    required this.borderColor,
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

      imageUrl: json['imageUrl'],

      location: json['location'],
      category: json['category'],
      borderColor: json['borderColor'],

      date: DateTime.parse(
        json['date'],
      ),

      participantsCount:
          json['participantsCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'title': title,

      'description': description,

      'imageUrl': imageUrl,

      'location': location,
      'category': category,
      'borderColor': borderColor,
      'date': date.toIso8601String(),

      'participantsCount':
          participantsCount,
    };
  }
}