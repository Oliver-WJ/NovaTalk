// import 'dart:convert';
//
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class AdLoadResult {
//   final Ad? ad;
//   final LoadAdError? error;
//
//   AdLoadResult({this.ad, this.error});
// }
//
// class AdData {
//   final String? source;
//   final int? level;
//   final String? type;
//   final String? id;
//   final int? timer;
//
//   AdData({
//     this.source,
//     this.level,
//     this.type,
//     this.id,
//     this.timer,
//   });
//
//   factory AdData.fromRawJson(String str) => AdData.fromJson(json.decode(str));
//
//   String toRawJson() => json.encode(toJson());
//
//   factory AdData.fromJson(Map<String, dynamic> json) => AdData(
//         source: json["source"],
//         level: json["level"],
//         type: json["type"],
//         id: json["id"],
//         timer: json["timer"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "source": source,
//         "level": level,
//         "type": type,
//         "id": id,
//         "timer": timer,
//       };
// }
