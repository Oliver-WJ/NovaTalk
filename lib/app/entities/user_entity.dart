import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/user_entity.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/user_entity.g.dart';

@JsonSerializable()
class UserEntity {
	String? id;
	@JSONField(name: "device_id")
	String? deviceId;
	dynamic token;
	String? platform;
	int? gems;
	@JSONField(name: "audio_switch")
	bool? audioSwitch;
	@JSONField(name: "subscription_end")
	dynamic subscriptionEnd;
	String? nickname;
	dynamic idfa;
	dynamic adid;
	@JSONField(name: "android_id")
	dynamic androidId;
	@JSONField(name: "gps_adid")
	dynamic gpsAdid;
	@JSONField(name: "auto_translate")
	bool? autoTranslate;
	@JSONField(name: "enable_auto_translate")
	bool? enableAutoTranslate;
	@JSONField(name: "source_language")
	String? sourceLanguage;
	@JSONField(name: "target_language")
	String? targetLanguage;
	dynamic sign;
	@JSONField(name: "free_message")
	dynamic freeMessage;
	dynamic visual;
	dynamic email;
	bool? activate;
	bool? pay;
	@JSONField(name: "undress_count")
	int? undressCount;
	@JSONField(name: "create_img")
	int? createImg;
	@JSONField(name: "create_video")
	int? createVideo;
	@JSONField(name: "video_unlock")
	bool? videoUnlock;
	bool? old;
	dynamic vip;
	@JSONField(name: "platform_name")
	String? platformName;

	UserEntity();

	factory UserEntity.fromJson(Map<String, dynamic> json) => $UserEntityFromJson(json);

	Map<String, dynamic> toJson() => $UserEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}