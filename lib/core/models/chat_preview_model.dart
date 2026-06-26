import 'package:flutter/painting.dart';

class ChatPreview {
  final String chatId;
  final String userId;
  final String lastMessageUserId;
  final String name;
  final String lastMessage;
  final String event;
  final String time;
  final bool unread;
  final String hostColor;
  final bool online;
  final String img;

  ChatPreview({
    required this.chatId,
    required this.userId,
    required this.lastMessageUserId,
    required this.name,
    required this.lastMessage,
    required this.event,
    required this.time,
    required this.unread,
    required this.hostColor,
    required this.online,
    required this.img,
  });

  factory ChatPreview.fromJson(Map<String, dynamic> json) {
    return ChatPreview(
      chatId: json['chatId'],
      userId: json['userId'],
      lastMessageUserId: json['lastMessageUserId'],
      name: json['name'],
      lastMessage: json['lastMessage'],
      event: json['event'],
      time: json['time'],
      unread: json['unread'] ?? false,
      hostColor: json['hostColor'],
      online: json['online'] ?? false,
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'userId': userId,
      'lastMessageUserId': lastMessageUserId,
      'name': name,
      'lastMessage': lastMessage,
      'event': event,
      'time': time,
      'unread': unread,
      'hostColor': hostColor,
      'online': online,
      'img': img,
    };
  }

  Color get hostColorValue => Color(int.parse(hostColor));
  bool get isMyMessage => lastMessageUserId == userId;
}
