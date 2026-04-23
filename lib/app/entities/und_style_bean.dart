import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/und_style_bean.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/und_style_bean.g.dart';

@JsonSerializable()
class UndStyleBean {
	String? name;
	String? style;
	String? url;
	String? icon;
	String? price;

	UndStyleBean();

	factory UndStyleBean.fromJson(Map<String, dynamic> json) => $UndStyleBeanFromJson(json);

	Map<String, dynamic> toJson() => $UndStyleBeanToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}