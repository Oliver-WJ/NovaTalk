import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/gen_resoult_bean.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/gen_resoult_bean.g.dart';

@JsonSerializable()
class GenResultBean {
	int? id;
	int? creationId;
	int? age;
	String? height;
	String? gender;
	int? styleId;
	bool? nsfw;
	List<GenResoultMoreDetails>? moreDetails;
	String? describeImg;
	String? prompt;
	String? imgs;
	String? platform;
	String? createTime;
	String? updateTime;
	bool? del;

	GenResultBean();

	factory GenResultBean.fromJson(Map<String, dynamic> json) => $GenResultBeanFromJson(json);

	Map<String, dynamic> toJson() => $GenResultBeanToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class GenResoultMoreDetails {
	int? id;
	String? name;
	List<GenResoultMoreDetailsTags>? tags;
	bool? required;
	String? defaultValue;
	int? orderNum;
	String? platform;
	String? createTime;
	String? updateTime;
	bool? del;

	GenResoultMoreDetails();

	factory GenResoultMoreDetails.fromJson(Map<String, dynamic> json) => $GenResoultMoreDetailsFromJson(json);

	Map<String, dynamic> toJson() => $GenResoultMoreDetailsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class GenResoultMoreDetailsTags {
	String? id;
	String? label;
	String? value;

	GenResoultMoreDetailsTags();

	factory GenResoultMoreDetailsTags.fromJson(Map<String, dynamic> json) => $GenResoultMoreDetailsTagsFromJson(json);

	Map<String, dynamic> toJson() => $GenResoultMoreDetailsTagsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}