import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/gen_photo_result_bean.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/gen_photo_result_bean.g.dart';

@JsonSerializable()
class GenPhotoResultBean {
	int? id;
	int? type;
	@JSONField(name: 'origin_url')
	String? originUrl;
	@JSONField(name: 'result_url')
	String? resultUrl;
	String? style;
	@JSONField(name: 'gen_img_id')
	int? genImgId;
	@JSONField(name: 'task_id')
	String? taskId;
	@JSONField(name: 'create_time')
	int? createTime;

	GenPhotoResultBean();

	factory GenPhotoResultBean.fromJson(Map<String, dynamic> json) => $GenPhotoResultBeanFromJson(json);

	Map<String, dynamic> toJson() => $GenPhotoResultBeanToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}