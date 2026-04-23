import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/role_tags_entity.dart';

RoleTagsEntity $RoleTagsEntityFromJson(Map<String, dynamic> json) {
  final RoleTagsEntity roleTagsEntity = RoleTagsEntity();
  final String? labelType = jsonConvert.convert<String>(json['label_type']);
  if (labelType != null) {
    roleTagsEntity.labelType = labelType;
  }
  final List<RoleTagsTagList>? tags = (json['tags'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<RoleTagsTagList>(e) as RoleTagsTagList)
      .toList();
  if (tags != null) {
    roleTagsEntity.tags = tags;
  }
  return roleTagsEntity;
}

Map<String, dynamic> $RoleTagsEntityToJson(RoleTagsEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['label_type'] = entity.labelType;
  data['tags'] = entity.tags?.map((v) => v.toJson()).toList();
  return data;
}

extension RoleTagsEntityExtension on RoleTagsEntity {
  RoleTagsEntity copyWith({
    String? labelType,
    List<RoleTagsTagList>? tags,
  }) {
    return RoleTagsEntity()
      ..labelType = labelType ?? this.labelType
      ..tags = tags ?? this.tags;
  }
}

RoleTagsTagList $RoleTagsTagListFromJson(Map<String, dynamic> json) {
  final RoleTagsTagList roleTagsTagList = RoleTagsTagList();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    roleTagsTagList.id = id;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    roleTagsTagList.name = name;
  }
  final String? labelType = jsonConvert.convert<String>(json['label_type']);
  if (labelType != null) {
    roleTagsTagList.labelType = labelType;
  }
  final String? remark = jsonConvert.convert<String>(json['remark']);
  if (remark != null) {
    roleTagsTagList.remark = remark;
  }
  return roleTagsTagList;
}

Map<String, dynamic> $RoleTagsTagListToJson(RoleTagsTagList entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['name'] = entity.name;
  data['label_type'] = entity.labelType;
  data['remark'] = entity.remark;
  return data;
}

extension RoleTagsTagListExtension on RoleTagsTagList {
  RoleTagsTagList copyWith({
    int? id,
    String? name,
    String? labelType,
    String? remark,
  }) {
    return RoleTagsTagList()
      ..id = id ?? this.id
      ..name = name ?? this.name
      ..labelType = labelType ?? this.labelType
      ..remark = remark ?? this.remark;
  }
}