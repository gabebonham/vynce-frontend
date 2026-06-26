import 'package:dio/dio.dart';

class CategoriesService {
  final Dio dio;

  CategoriesService(this.dio);

  Future<List<String>> getCategories() async {
    return Future.value(['Música', 'Tech', 'Festa', 'Arte', 'Gastronomia']);
  }
}
