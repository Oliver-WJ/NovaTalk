import 'dart:convert';

class RecordBean<T> {
  List<T>? records;
  int? total;
  int? size;
  int? current;
  int? pages;

  RecordBean({this.records, this.total, this.size, this.current, this.pages});

  static RecordBean<T> fromJsonByList<T>(
    Map<String, dynamic> json, {
    T Function(Map<String, dynamic>)? decodeJson,
  }) {
    var rawData = json['records'];
    if (decodeJson != null && rawData is List) {
      rawData = rawData.map((e) => decodeJson(e)).toList();
    }
    return RecordBean<T>(
      records: rawData,
      total: json['total'],
      size: json['size'],
      current: json['current'],
      pages: json['pages'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': records,
      'total': total,
      'size': size,
      'current': current,
      'pages': pages,
    };
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}
