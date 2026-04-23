import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/moment_bean.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/moment_bean.g.dart';

@JsonSerializable()
class MomentBean {
	int? id;
	@JSONField(name: 'character_avatar')
	String? characterAvatar;
	@JSONField(name: 'character_id')
	String? characterId;
	@JSONField(name: 'character_name')
	String? characterName;
	String? cover;
	@JSONField(name: 'create_time')
	dynamic createTime;
	dynamic duration;
	@JSONField(name: 'hide_character')
	bool? hideCharacter;
	bool? istop;
	String? media;
	@JSONField(name: 'media_text')
	dynamic mediaText;
	String? text;
	@JSONField(name: 'update_time')
	dynamic updateTime;
	bool? unlocked;
	int? price;

	MomentBean();

	factory MomentBean.fromJson(Map<String, dynamic> json) => $MomentBeanFromJson(json);

	Map<String, dynamic> toJson() => $MomentBeanToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}