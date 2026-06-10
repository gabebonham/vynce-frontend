class MessageModel {
  final String id;
  final String profileId;
  final String friendId;
  final bool read;
  final bool sent;
  final bool mine;
  final String textMessage;
  // final String imgMessageUrl;
  // final String audioMessageUrl;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.profileId,
    required this.friendId,
    required this.read,
    required this.sent,
    required this.mine,
    required this.textMessage,
    required this.createdAt,
  });

  static List<MessageModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MessageModel.fromJson(json)).toList();
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      mine: json['mine'],
      profileId: json['profileId'],
      friendId: json['friendId'],
      read: json['read'] ?? false,
      sent: json['sent'] ?? false,
      textMessage: json['textMessage'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profileId': profileId,
      'mine': mine,
      'friendId': friendId,
      'read': read,
      'sent': sent,
      'textMessage': textMessage,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
