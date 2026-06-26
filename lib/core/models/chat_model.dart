import 'package:vynce_frontend/core/models/event_model.dart';
import 'package:vynce_frontend/core/models/message_model.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';

class ChatModel {
  final String id;
  final ProfileModel profile;
  final ProfileModel friend;
  final EventModel? event;
  final int messagesCount;
  final int unreadMessagesCount;
  final MessageModel? lastMessage;
  final List<MessageModel> messages;
  final bool online;
  final DateTime createdAt;

  ChatModel({
    required this.id,
    required this.profile,
    required this.friend,
    required this.event,
    required this.messagesCount,
    required this.unreadMessagesCount,
    this.lastMessage,
    required this.messages,
    required this.online,
    required this.createdAt,
  });

  static List<ChatModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ChatModel.fromJson(json)).toList();
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      online: json['online'],
      event: json['event'] != null ? EventModel.fromJson(json["event"]) : null,
      profile: ProfileModel.fromJson(json['profile']),
      friend: ProfileModel.fromJson(json['friend']),
      messagesCount: json['messagesCount'] ?? 0,
      unreadMessagesCount: json['unreadMessagesCount'] ?? 0,
      lastMessage: json['lastMessage'] != null
          ? MessageModel.fromJson(json['lastMessage'])
          : null,
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((m) => MessageModel.fromJson(m))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'profile': profile.toJson(),
      'event': event?.toJson(),
      'friend': friend.toJson(),
      'online': online,
      'messagesCount': messagesCount,
      'unreadMessagesCount': unreadMessagesCount,
      'lastMessage': lastMessage?.toJson(),
      'messages': messages.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
