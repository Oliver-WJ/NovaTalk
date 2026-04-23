import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/gen_photo_result_bean.dart';

GenPhotoResultBean $GenPhotoResultBeanFromJson(Map<String, dynamic> json) {
  final GenPhotoResultBean genPhotoResultBean = GenPhotoResultBean();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    genPhotoResultBean.id = id;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    genPhotoResultBean.type = type;
  }
  final String? originUrl = jsonConvert.convert<String>(json['origin_url']);
  if (originUrl != null) {
    genPhotoResultBean.originUrl = originUrl;
  }
  final String? resultUrl = jsonConvert.convert<String>(json['result_url']);
  if (resultUrl != null) {
    genPhotoResultBean.resultUrl = resultUrl;
  }
  final String? style = jsonConvert.convert<String>(json['style']);
  if (style != null) {
    genPhotoResultBean.style = style;
  }
  final int? genImgId = jsonConvert.convert<int>(json['gen_img_id']);
  if (genImgId != null) {
    genPhotoResultBean.genImgId = genImgId;
  }
  final String? taskId = jsonConvert.convert<String>(json['task_id']);
  if (taskId != null) {
    genPhotoResultBean.taskId = taskId;
  }
  final int? createTime = jsonConvert.convert<int>(json['create_time']);
  if (createTime != null) {
    genPhotoResultBean.createTime = createTime;
  }
  return genPhotoResultBean;
}

Map<String, dynamic> $GenPhotoResultBeanToJson(GenPhotoResultBean entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['type'] = entity.type;
  data['origin_url'] = entity.originUrl;
  data['result_url'] = entity.resultUrl;
  data['style'] = entity.style;
  data['gen_img_id'] = entity.genImgId;
  data['task_id'] = entity.taskId;
  data['create_time'] = entity.createTime;
  return data;
}

extension GenPhotoResultBeanExtension on GenPhotoResultBean {
  GenPhotoResultBean copyWith({
    int? id,
    int? type,
    String? originUrl,
    String? resultUrl,
    String? style,
    int? genImgId,
    String? taskId,
    int? createTime,
  }) {
    return GenPhotoResultBean()
      ..id = id ?? this.id
      ..type = type ?? this.type
      ..originUrl = originUrl ?? this.originUrl
      ..resultUrl = resultUrl ?? this.resultUrl
      ..style = style ?? this.style
      ..genImgId = genImgId ?? this.genImgId
      ..taskId = taskId ?? this.taskId
      ..createTime = createTime ?? this.createTime;
  }
}