import 'package:novatalk/generated/json/base/json_field.dart';
import 'package:novatalk/generated/json/conversation_entity.g.dart';
import 'dart:convert';
export 'package:novatalk/generated/json/conversation_entity.g.dart';

@JsonSerializable()
class ConversationEntity {
	List<ConversationRecords>? records;
	int? total;
	int? size;
	int? current;
	int? pages;

	ConversationEntity();

	factory ConversationEntity.fromJson(Map<String, dynamic> json) => $ConversationEntityFromJson(json);

	Map<String, dynamic> toJson() => $ConversationEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class ConversationRecords {
	String? id;
	String? avatar;
	@JSONField(name: "user_id")
	String? userId;
	String? title;
	bool? pinned;
	@JSONField(name: "pinned_time")
	dynamic pinnedTime;
	@JSONField(name: "character_id")
	String? characterId;
	dynamic model;
	@JSONField(name: "template_id")
	int? templateId;
	@JSONField(name: "voice_model")
	String? voiceModel;
	@JSONField(name: "last_message")
	dynamic lastMessage;
	@JSONField(name: "update_time")
	int? updateTime;
	@JSONField(name: "create_time")
	int? createTime;
	bool? collect;
	@JSONField(name: "user_chat_level")
	ConversationRecordsUserChatLevel? userChatLevel;
	String? mode;
	String? background;
	int? cid;
	String? scene;
	@JSONField(name: "profile_id")
	String? profileId;
	@JSONField(name: "chat_model")
	String? chatModel;
	@JSONField(name: "language_code")
	String? languageCode;

	ConversationRecords();

	factory ConversationRecords.fromJson(Map<String, dynamic> json) => $ConversationRecordsFromJson(json);

	Map<String, dynamic> toJson() => $ConversationRecordsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class ConversationRecordsUserChatLevel {
	int? id;
	@JSONField(name: "user_id")
	String? userId;
	@JSONField(name: "conversation_id")
	int? conversationId;
	@JSONField(name: "char_id")
	String? charId;
	int? level;
	int? num;
	double? progress;
	@JSONField(name: "upgrade_requirements")
	double? upgradeRequirements;
	int? rewards;

	ConversationRecordsUserChatLevel();

	factory ConversationRecordsUserChatLevel.fromJson(Map<String, dynamic> json) => $ConversationRecordsUserChatLevelFromJson(json);

	Map<String, dynamic> toJson() => $ConversationRecordsUserChatLevelToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}