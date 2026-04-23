import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/people_mask_entity.dart';

PeopleMaskEntity $PeopleMaskEntityFromJson(Map<String, dynamic> json) {
  final PeopleMaskEntity peopleMaskEntity = PeopleMaskEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    peopleMaskEntity.id = id;
  }
  final String? userId = jsonConvert.convert<String>(json['user_id']);
  if (userId != null) {
    peopleMaskEntity.userId = userId;
  }
  final String? profileName = jsonConvert.convert<String>(json['profile_name']);
  if (profileName != null) {
    peopleMaskEntity.profileName = profileName;
  }
  final int? gender = jsonConvert.convert<int>(json['gender']);
  if (gender != null) {
    peopleMaskEntity.gender = gender;
  }
  final int? age = jsonConvert.convert<int>(json['age']);
  if (age != null) {
    peopleMaskEntity.age = age;
  }
  final String? description = jsonConvert.convert<String>(json['description']);
  if (description != null) {
    peopleMaskEntity.description = description;
  }
  final String? otherInfo = jsonConvert.convert<String>(json['other_info']);
  if (otherInfo != null) {
    peopleMaskEntity.otherInfo = otherInfo;
  }
  final String? createTime = jsonConvert.convert<String>(json['create_time']);
  if (createTime != null) {
    peopleMaskEntity.createTime = createTime;
  }
  final String? updateTime = jsonConvert.convert<String>(json['update_time']);
  if (updateTime != null) {
    peopleMaskEntity.updateTime = updateTime;
  }
  return peopleMaskEntity;
}

Map<String, dynamic> $PeopleMaskEntityToJson(PeopleMaskEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['user_id'] = entity.userId;
  data['profile_name'] = entity.profileName;
  data['gender'] = entity.gender;
  data['age'] = entity.age;
  data['description'] = entity.description;
  data['other_info'] = entity.otherInfo;
  data['create_time'] = entity.createTime;
  data['update_time'] = entity.updateTime;
  return data;
}

extension PeopleMaskEntityExtension on PeopleMaskEntity {
  PeopleMaskEntity copyWith({
    int? id,
    String? userId,
    String? profileName,
    int? gender,
    int? age,
    String? description,
    String? otherInfo,
    String? createTime,
    String? updateTime,
  }) {
    return PeopleMaskEntity()
      ..id = id ?? this.id
      ..userId = userId ?? this.userId
      ..profileName = profileName ?? this.profileName
      ..gender = gender ?? this.gender
      ..age = age ?? this.age
      ..description = description ?? this.description
      ..otherInfo = otherInfo ?? this.otherInfo
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime;
  }
}