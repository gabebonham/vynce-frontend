import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:vynce_frontend/core/models/profile_model.dart';

class ProfileService {
  final Dio dio;

  ProfileService(this.dio);

  Future<ProfileModel> getProfile(String id) async {
    // final response = await dio.get('/profiles');
    final String response = await rootBundle.loadString(
      'assets/mocks/profile_mock.json',
    );

    final dynamic data = jsonDecode(response);
    return ProfileModel.fromJson(data);
  }
}
