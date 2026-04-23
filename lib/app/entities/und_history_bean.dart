import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/und_history_bean.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/und_history_bean.g.dart';

@JsonSerializable()
class UndHistoryBean {
	int? id;
	@JSONField(name: 'user_id')
	String? userId;
	@JSONField(name: 'character_id')
	String? characterId;
	String? url;
	@JSONField(name: 'origin_url')
	String? originUrl;
	String? platform;
	String? style;
	@JSONField(name: 'create_time')
	int? createTime;
	@JSONField(name: 'update_time')
	int? updateTime;
	bool? consumption;
	@JSONField(name: 'task_id')
	String? taskId;
	int? type;
	@JSONField(name: 'file_md5')
	dynamic fileMd5;

	UndHistoryBean();

	factory UndHistoryBean.fromJson(Map<String, dynamic> json) => $UndHistoryBeanFromJson(json);

	Map<String, dynamic> toJson() => $UndHistoryBeanToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}