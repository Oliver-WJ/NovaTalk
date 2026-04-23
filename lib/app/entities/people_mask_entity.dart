import 'dart:convert';

import '../../generated/json/base/json_field.dart';
import '../../generated/json/people_mask_entity.g.dart';



@JsonSerializable()
class PeopleMaskEntity {
  int? id;
  @JSONField(name: "user_id")
  String? userId = '';
  @JSONField(name: "profile_name")
  String? profileName = '';
  int? gender;
  int? age;
  String? description = '';
  @JSONField(name: "other_info")
  String? otherInfo;
  @JSONField(name: "create_time")
  String? createTime = '';
  @JSONField(name: "update_time")
  String? updateTime = '';

  PeopleMaskEntity();

  factory PeopleMaskEntity.fromJson(Map<String, dynamic> json) => $PeopleMaskEntityFromJson(json);

  Map<String, dynamic> toJson() => $PeopleMaskEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PeopleMaskEntity && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

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
  }){
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
