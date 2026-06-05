import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:vynce_frontend/features/events/data/models/host_model.dart';
import 'package:vynce_frontend/features/events/data/models/profile_model.dart';

class HostService {
  final Dio dio;

  HostService(this.dio);

  Future<HostModel> getProfile(String id) async {
    final String response = await rootBundle.loadString(
      'assets/mocks/host_mock.json',
    );

    final dynamic data = jsonDecode(response);
    return HostModel.fromJson(data);
  }
}
