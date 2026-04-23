import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/und_img_result_bean.dart';

UndImgResultBean $UndImgResultBeanFromJson(Map<String, dynamic> json) {
  final UndImgResultBean undImgResultBean = UndImgResultBean();
  final String? uid = jsonConvert.convert<String>(json['uid']);
  if (uid != null) {
    undImgResultBean.uid = uid;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    undImgResultBean.status = status;
  }
  final List<String>? results = (json['results'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (results != null) {
    undImgResultBean.results = results;
  }
  return undImgResultBean;
}

Map<String, dynamic> $UndImgResultBeanToJson(UndImgResultBean entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['uid'] = entity.uid;
  data['status'] = entity.status;
  data['results'] = entity.results;
  return data;
}

extension UndImgResultBeanExtension on UndImgResultBean {
  UndImgResultBean copyWith({
    String? uid,
    int? status,
    List<String>? results,
  }) {
    return UndImgResultBean()
      ..uid = uid ?? this.uid
      ..status = status ?? this.status
      ..results = results ?? this.results;
  }
}