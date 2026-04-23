import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/und_video_result_bean.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/und_video_result_bean.g.dart';

@JsonSerializable()
class UndVideoResultBean {
	UndVideoResultItem? item;

	UndVideoResultBean();

	factory UndVideoResultBean.fromJson(Map<String, dynamic> json) => $UndVideoResultBeanFromJson(json);

	Map<String, dynamic> toJson() => $UndVideoResultBeanToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UndVideoResultItem {
	String? uid;
	int? status;
	@JSONField(name: 'result_path')
	String? resultPath;
	@JSONField(name: 'image_path')
	String? imagePath;
	String? time;
	@JSONField(name: 'time_need')
	int? timeNeed;
	@JSONField(name: 'estimated_time')
	int? estimatedTime;

	UndVideoResultItem();

	factory UndVideoResultItem.fromJson(Map<String, dynamic> json) => $UndVideoResultItemFromJson(json);

	Map<String, dynamic> toJson() => $UndVideoResultItemToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}