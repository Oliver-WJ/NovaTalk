import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/und_video_result_bean.dart';

UndVideoResultBean $UndVideoResultBeanFromJson(Map<String, dynamic> json) {
  final UndVideoResultBean undVideoResultBean = UndVideoResultBean();
  final UndVideoResultItem? item = jsonConvert.convert<UndVideoResultItem>(
      json['item']);
  if (item != null) {
    undVideoResultBean.item = item;
  }
  return undVideoResultBean;
}

Map<String, dynamic> $UndVideoResultBeanToJson(UndVideoResultBean entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['item'] = entity.item?.toJson();
  return data;
}

extension UndVideoResultBeanExtension on UndVideoResultBean {
  UndVideoResultBean copyWith({
    UndVideoResultItem? item,
  }) {
    return UndVideoResultBean()
      ..item = item ?? this.item;
  }
}

UndVideoResultItem $UndVideoResultItemFromJson(Map<String, dynamic> json) {
  final UndVideoResultItem undVideoResultItem = UndVideoResultItem();
  final String? uid = jsonConvert.convert<String>(json['uid']);
  if (uid != null) {
    undVideoResultItem.uid = uid;
  }
  final int? status = jsonConvert.convert<int>(json['status']);
  if (status != null) {
    undVideoResultItem.status = status;
  }
  final String? resultPath = jsonConvert.convert<String>(json['result_path']);
  if (resultPath != null) {
    undVideoResultItem.resultPath = resultPath;
  }
  final String? imagePath = jsonConvert.convert<String>(json['image_path']);
  if (imagePath != null) {
    undVideoResultItem.imagePath = imagePath;
  }
  final String? time = jsonConvert.convert<String>(json['time']);
  if (time != null) {
    undVideoResultItem.time = time;
  }
  final int? timeNeed = jsonConvert.convert<int>(json['time_need']);
  if (timeNeed != null) {
    undVideoResultItem.timeNeed = timeNeed;
  }
  final int? estimatedTime = jsonConvert.convert<int>(json['estimated_time']);
  if (estimatedTime != null) {
    undVideoResultItem.estimatedTime = estimatedTime;
  }
  return undVideoResultItem;
}

Map<String, dynamic> $UndVideoResultItemToJson(UndVideoResultItem entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['uid'] = entity.uid;
  data['status'] = entity.status;
  data['result_path'] = entity.resultPath;
  data['image_path'] = entity.imagePath;
  data['time'] = entity.time;
  data['time_need'] = entity.timeNeed;
  data['estimated_time'] = entity.estimatedTime;
  return data;
}

extension UndVideoResultItemExtension on UndVideoResultItem {
  UndVideoResultItem copyWith({
    String? uid,
    int? status,
    String? resultPath,
    String? imagePath,
    String? time,
    int? timeNeed,
    int? estimatedTime,
  }) {
    return UndVideoResultItem()
      ..uid = uid ?? this.uid
      ..status = status ?? this.status
      ..resultPath = resultPath ?? this.resultPath
      ..imagePath = imagePath ?? this.imagePath
      ..time = time ?? this.time
      ..timeNeed = timeNeed ?? this.timeNeed
      ..estimatedTime = estimatedTime ?? this.estimatedTime;
  }
}