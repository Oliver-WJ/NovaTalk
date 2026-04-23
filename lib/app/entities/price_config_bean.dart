import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/price_config_bean.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/price_config_bean.g.dart';

@JsonSerializable()
class PriceConfigBean {
	@JSONField(name: 'scene_change')
	int? sceneChange;
	@JSONField(name: 'text_message')
	int? textMessage;
	@JSONField(name: 'audio_message')
	int? audioMessage;
	@JSONField(name: 'photo_message')
	int? photoMessage;
	@JSONField(name: 'video_message')
	int? videoMessage;
	@JSONField(name: 'generate_image')
	int? generateImage;
	@JSONField(name: 'generate_video')
	int? generateVideo;
	@JSONField(name: 'profile_change')
	int? profileChange;
	@JSONField(name: 'call_ai_characters')
	int? callAiCharacters;

	PriceConfigBean();

	factory PriceConfigBean.fromJson(Map<String, dynamic> json) => $PriceConfigBeanFromJson(json);

	Map<String, dynamic> toJson() => $PriceConfigBeanToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}