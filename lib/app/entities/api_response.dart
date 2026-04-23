import 'dart:convert';


const insufficientBalance = 20003;

class ApiResponse<T> {
  final bool? success;
  final int? code;
  final String? message;
  final T? data;

  ApiResponse({this.success, this.code, this.message, this.data});

  static ApiResponse<List<T>> fromJsonByList<T>(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic>)? decodeJson,
  }) {
    var rawData = json['data'];
    if (decodeJson != null && rawData is List) {
      rawData = rawData.map((e) => decodeJson(e)).toList();
    }
    return ApiResponse(
      code: json['code'],
      message: json['message'],
      success: json['success'],
      data: rawData,
    );
  }

  static ApiResponse<T> fromJson<T>(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic>)? decodeJson,
  }) {
    var rawData = json['data'];
    if (decodeJson != null && rawData is Map<String, dynamic>) {
      rawData = decodeJson(rawData);
    }
    return ApiResponse(
      code: json['code'],
      message: json['message'],
      success: json['success'],
      data: rawData,
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'code': code, 'message': message, 'data': data};
  }
}

List<T> parseList<T>(dynamic value, T Function(dynamic map) parse) {
  List<dynamic> parsed = value;
  if (value is String) {
    parsed = jsonDecode(value).cast<Map<String, dynamic>>();
  }
  return parsed.map<T>(parse).toList();
}

