import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/role_tags_entity.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/role_tags_entity.g.dart';

@JsonSerializable()
class RoleTagsEntity {
	@JSONField(name: "label_type")
	String? labelType;
	List<RoleTagsTagList>? tags;

	RoleTagsEntity();

	factory RoleTagsEntity.fromJson(Map<String, dynamic> json) => $RoleTagsEntityFromJson(json);

	Map<String, dynamic> toJson() => $RoleTagsEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class RoleTagsTagList {
	int? id;
	String? name;
	@JSONField(name: "label_type")
	String? labelType;
	String? remark;

	RoleTagsTagList();

	factory RoleTagsTagList.fromJson(Map<String, dynamic> json) => $RoleTagsTagListFromJson(json);

	Map<String, dynamic> toJson() => $RoleTagsTagListToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}