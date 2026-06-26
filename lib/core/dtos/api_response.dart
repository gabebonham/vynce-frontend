class ApiResponse<T> {
  final T data;
  final bool success;
  final String message;

  ApiResponse({
    required this.data,
    required this.success,
    required this.message,
  });

  factory ApiResponse.fromJson(dynamic json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      data: fromJsonT(json['data']),
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  static List<T> fromJsonList<T>(
    List<dynamic> jsonList,
    T Function(dynamic) fromJsonT,
  ) {
    return jsonList.map((json) => fromJsonT(json)).toList();
  }
}
