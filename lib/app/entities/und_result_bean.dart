import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/und_result_bean.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/und_result_bean.g.dart';

@JsonSerializable()
class UndResultBean {
	int? code;
	String? message;
	UndResultData? data;

	UndResultBean();

	factory UndResultBean.fromJson(Map<String, dynamic> json) => $UndResultBeanFromJson(json);

	Map<String, dynamic> toJson() => $UndResultBeanToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class UndResultData {
	String? uid;
	@JSONField(name: 'estimated_time')
	int? estimatedTime;

	UndResultData();

	factory UndResultData.fromJson(Map<String, dynamic> json) => $UndResultDataFromJson(json);

	Map<String, dynamic> toJson() => $UndResultDataToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}