import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/und_img_result_bean.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/und_img_result_bean.g.dart';

@JsonSerializable()
class UndImgResultBean {
	String? uid;
	int? status;
	List<String>? results;

	UndImgResultBean();

	factory UndImgResultBean.fromJson(Map<String, dynamic> json) => $UndImgResultBeanFromJson(json);

	Map<String, dynamic> toJson() => $UndImgResultBeanToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}