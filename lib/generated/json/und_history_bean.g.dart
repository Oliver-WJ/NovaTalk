import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/und_history_bean.dart';

UndHistoryBean $UndHistoryBeanFromJson(Map<String, dynamic> json) {
  final UndHistoryBean undHistoryBean = UndHistoryBean();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    undHistoryBean.id = id;
  }
  final String? userId = jsonConvert.convert<String>(json['user_id']);
  if (userId != null) {
    undHistoryBean.userId = userId;
  }
  final String? characterId = jsonConvert.convert<String>(json['character_id']);
  if (characterId != null) {
    undHistoryBean.characterId = characterId;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    undHistoryBean.url = url;
  }
  final String? originUrl = jsonConvert.convert<String>(json['origin_url']);
  if (originUrl != null) {
    undHistoryBean.originUrl = originUrl;
  }
  final String? platform = jsonConvert.convert<String>(json['platform']);
  if (platform != null) {
    undHistoryBean.platform = platform;
  }
  final String? style = jsonConvert.convert<String>(json['style']);
  if (style != null) {
    undHistoryBean.style = style;
  }
  final int? createTime = jsonConvert.convert<int>(json['create_time']);
  if (createTime != null) {
    undHistoryBean.createTime = createTime;
  }
  final int? updateTime = jsonConvert.convert<int>(json['update_time']);
  if (updateTime != null) {
    undHistoryBean.updateTime = updateTime;
  }
  final bool? consumption = jsonConvert.convert<bool>(json['consumption']);
  if (consumption != null) {
    undHistoryBean.consumption = consumption;
  }
  final String? taskId = jsonConvert.convert<String>(json['task_id']);
  if (taskId != null) {
    undHistoryBean.taskId = taskId;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    undHistoryBean.type = type;
  }
  final dynamic fileMd5 = json['file_md5'];
  if (fileMd5 != null) {
    undHistoryBean.fileMd5 = fileMd5;
  }
  return undHistoryBean;
}

Map<String, dynamic> $UndHistoryBeanToJson(UndHistoryBean entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['user_id'] = entity.userId;
  data['character_id'] = entity.characterId;
  data['url'] = entity.url;
  data['origin_url'] = entity.originUrl;
  data['platform'] = entity.platform;
  data['style'] = entity.style;
  data['create_time'] = entity.createTime;
  data['update_time'] = entity.updateTime;
  data['consumption'] = entity.consumption;
  data['task_id'] = entity.taskId;
  data['type'] = entity.type;
  data['file_md5'] = entity.fileMd5;
  return data;
}

extension UndHistoryBeanExtension on UndHistoryBean {
  UndHistoryBean copyWith({
    int? id,
    String? userId,
    String? characterId,
    String? url,
    String? originUrl,
    String? platform,
    String? style,
    int? createTime,
    int? updateTime,
    bool? consumption,
    String? taskId,
    int? type,
    dynamic fileMd5,
  }) {
    return UndHistoryBean()
      ..id = id ?? this.id
      ..userId = userId ?? this.userId
      ..characterId = characterId ?? this.characterId
      ..url = url ?? this.url
      ..originUrl = originUrl ?? this.originUrl
      ..platform = platform ?? this.platform
      ..style = style ?? this.style
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..consumption = consumption ?? this.consumption
      ..taskId = taskId ?? this.taskId
      ..type = type ?? this.type
      ..fileMd5 = fileMd5 ?? this.fileMd5;
  }
}