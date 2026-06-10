import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:vynce_frontend/features/events/data/dtos/api_response.dart';
import 'package:vynce_frontend/features/events/data/models/chat_model.dart';
import 'package:vynce_frontend/features/events/data/models/chat_preview_model.dart';

class ChatsService {
  final Dio dio;

  ChatsService(this.dio);

  Future<ApiResponse<List<ChatPreview>>> getChatPreviews() async {
    final String response = await rootBundle.loadString(
      'assets/mocks/chats_preview_mocks.json',
    );

    final List<dynamic> data = jsonDecode(response);
    final chats = data.map((e) => ChatPreview.fromJson(e)).toList();

    return ApiResponse(data: chats, success: true, message: '');
  }

  Future<ApiResponse<ChatModel>> getChat(String id) async {
    final String response = await rootBundle.loadString(
      'assets/mocks/chats_mocks.json',
    );

    final List<dynamic> data = jsonDecode(response);
    final chatJson = data.firstWhere(
      (e) => e['id'] == id,
      orElse: () => throw Exception('Chat $id não encontrado'),
    );

    return ApiResponse(
      data: ChatModel.fromJson(chatJson),
      success: true,
      message: '',
    );
  }
}
