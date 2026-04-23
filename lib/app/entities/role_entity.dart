import 'package:novatalk/app/entities/character_video_chat.dart';
import 'package:novatalk/app/entities/msg_clothing.dart';
import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/role_entity.g.dart';
import 'dart:convert';

export 'package:novatalk/generated/json/role_entity.g.dart';

@JsonSerializable()
class RoleEntity {
	List<RoleRecords>? records;
	int? total;
	int? size;
	int? current;
	int? pages;

	RoleEntity();

	factory RoleEntity.fromJson(Map<String, dynamic> json) => $RoleEntityFromJson(json);

	Map<String, dynamic> toJson() => $RoleEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class RoleRecords {
  String? id;
  int? age;
  @JSONField(name: "about_me")
  String? aboutMe;
  RoleRecordsMedia? media;
  List<RoleRecordsImages>? images;
  String? avatar;
  @JSONField(name: "avatar_video")
  String? avatarVideo;
  String? name;
  String? platform;
  @JSONField(name: "render_style")
  String? renderStyle;
  String? likes;
  List<String>? greetings;
  @JSONField(name: "greetings_voice")
  List<GreetingsVoice>? greetingsVoice;
  @JSONField(name: "session_count")
  String? sessionCount;
  bool? vip;
  @JSONField(name: "order_num")
  int? orderNum;
  List<String>? tags;
  @JSONField(name: "tag_type")
  String? tagType;
  String? scenario;
  double? temperature;
  @JSONField(name: "voice_id")
  String? voiceId;
  String? engine;
  int? gender;
  @JSONField(name: "video_chat")
  bool? videoChat;
  @JSONField(name: "character_video_chat")
  List<CharacterVideoChat>? characterVideoChat;
  @JSONField(name: "gen_photo_tags")
  List<String>? genPhotoTags;
  @JSONField(name: "gen_video_tags")
  List<String>? genVideoTags;
  @JSONField(name: "gen_photo")
  bool? genPhoto;
  @JSONField(name: "gen_video")
  bool? genVideo;
  bool? gems;
  bool? collect;
  @JSONField(name: "last_message")
  String? lastMessage;
  String? intro;
  @JSONField(name: "change_clothing")
  bool? changeClothing;
  @JSONField(name: "change_clothes")
  List<ChangeClothe>? changeClothes;
  @JSONField(name: "update_time")
  String? updateTime;
  @JSONField(name: "chat_num")
  int? chatNum;
  @JSONField(name: "msg_num")
  int? msgNum;
  String? mode;
  int? cid;
  @JSONField(name: "character_origin")
  String? characterOrigin;
  String? origin;
  @JSONField(name: "card_num")
  int? cardNum;
  @JSONField(name: "unlock_card_num")
  int? unlockCardNum;
  int? price;
  @JSONField(name: "create_user_id")
  String? createUserId;
  @JSONField(name: "create_user_name")
  String? createUserName;
  @JSONField(name: "audit_status")
  String? auditStatus;

	RoleRecords();

	factory RoleRecords.fromJson(Map<String, dynamic> json) => $RoleRecordsFromJson(json);

	Map<String, dynamic> toJson() => $RoleRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class GreetingsVoice {
  String? url;
  int? duration;

  GreetingsVoice({
    this.url,
    this.duration,
  });

  factory GreetingsVoice.fromJson(Map<String, dynamic> json) => $GreetingsVoiceFromJson(json);
  Map<String, dynamic> toJson() => $GreetingsVoiceToJson(this);
}

@JsonSerializable()
class RoleRecordsMedia {
	@JSONField(name: "character_images")
	List<String>? characterImages;

	RoleRecordsMedia();

	factory RoleRecordsMedia.fromJson(Map<String, dynamic> json) => $RoleRecordsMediaFromJson(json);

	Map<String, dynamic> toJson() => $RoleRecordsMediaToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class RoleRecordsImages {
	int? id;
	@JSONField(name: "create_time")
	dynamic createTime;
	@JSONField(name: "update_time")
	dynamic updateTime;
	@JSONField(name: "image_url")
	String? imageUrl;
	@JSONField(name: "model_id")
	String? modelId;
	int? gems;
	@JSONField(name: "img_type")
	int? imgType;
	@JSONField(name: "img_remark")
	dynamic imgRemark;
	bool? unlocked;

	RoleRecordsImages();

	factory RoleRecordsImages.fromJson(Map<String, dynamic> json) => $RoleRecordsImagesFromJson(json);

	Map<String, dynamic> toJson() => $RoleRecordsImagesToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class RoleRecordsCharacterVideoChat {
	int? id;
	@JSONField(name: "character_id")
	String? characterId;
	String? tag;
	int? duration;
	String? url;
	@JSONField(name: "gif_url")
	String? gifUrl;
	@JSONField(name: "create_time")
	dynamic createTime;
	@JSONField(name: "update_time")
	dynamic updateTime;

	RoleRecordsCharacterVideoChat();

	factory RoleRecordsCharacterVideoChat.fromJson(Map<String, dynamic> json) => $RoleRecordsCharacterVideoChatFromJson(json);

	Map<String, dynamic> toJson() => $RoleRecordsCharacterVideoChatToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}