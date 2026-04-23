import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/und_result_bean.dart';

UndResultBean $UndResultBeanFromJson(Map<String, dynamic> json) {
  final UndResultBean undResultBean = UndResultBean();
  final int? code = jsonConvert.convert<int>(json['code']);
  if (code != null) {
    undResultBean.code = code;
  }
  final String? message = jsonConvert.convert<String>(json['message']);
  if (message != null) {
    undResultBean.message = message;
  }
  final UndResultData? data = jsonConvert.convert<UndResultData>(json['data']);
  if (data != null) {
    undResultBean.data = data;
  }
  return undResultBean;
}

Map<String, dynamic> $UndResultBeanToJson(UndResultBean entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['code'] = entity.code;
  data['message'] = entity.message;
  data['data'] = entity.data?.toJson();
  return data;
}

extension UndResultBeanExtension on UndResultBean {
  UndResultBean copyWith({
    int? code,
    String? message,
    UndResultData? data,
  }) {
    return UndResultBean()
      ..code = code ?? this.code
      ..message = message ?? this.message
      ..data = data ?? this.data;
  }
}

UndResultData $UndResultDataFromJson(Map<String, dynamic> json) {
  final UndResultData undResultData = UndResultData();
  final String? uid = jsonConvert.convert<String>(json['uid']);
  if (uid != null) {
    undResultData.uid = uid;
  }
  final int? estimatedTime = jsonConvert.convert<int>(json['estimated_time']);
  if (estimatedTime != null) {
    undResultData.estimatedTime = estimatedTime;
  }
  return undResultData;
}

Map<String, dynamic> $UndResultDataToJson(UndResultData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['uid'] = entity.uid;
  data['estimated_time'] = entity.estimatedTime;
  return data;
}

extension UndResultDataExtension on UndResultData {
  UndResultData copyWith({
    String? uid,
    int? estimatedTime,
  }) {
    return UndResultData()
      ..uid = uid ?? this.uid
      ..estimatedTime = estimatedTime ?? this.estimatedTime;
  }
}