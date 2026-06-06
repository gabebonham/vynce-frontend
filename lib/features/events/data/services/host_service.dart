import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:vynce_frontend/features/events/data/models/host_model.dart';

class HostService {
  final Dio dio;

  HostService(this.dio);

  Future<HostModel> getHost(String id) async {
    final String response = await rootBundle.loadString(
      'assets/mocks/host_mock.json',
    );

    final dynamic data = jsonDecode(response);
    return HostModel.fromJson(data);
  }
}
