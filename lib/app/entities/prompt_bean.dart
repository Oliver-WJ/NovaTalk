import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/prompt_bean.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/prompt_bean.g.dart';

@JsonSerializable()
class PromptBean {
	int? id;
	@JSONField(name: 'title_en')
	String? titleEn;
	@JSONField(name: 'title_cn')
	String? titleCn;
	String? category;
	String? prompt;

	PromptBean();

	factory PromptBean.fromJson(Map<String, dynamic> json) => $PromptBeanFromJson(json);

	Map<String, dynamic> toJson() => $PromptBeanToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}