import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/conversation_entity.dart';

ConversationEntity $ConversationEntityFromJson(Map<String, dynamic> json) {
  final ConversationEntity conversationEntity = ConversationEntity();
  final List<ConversationRecords>? records = (json['records'] as List<dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<ConversationRecords>(e) as ConversationRecords)
      .toList();
  if (records != null) {
    conversationEntity.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    conversationEntity.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    conversationEntity.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    conversationEntity.current = current;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    conversationEntity.pages = pages;
  }
  return conversationEntity;
}

Map<String, dynamic> $ConversationEntityToJson(ConversationEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['records'] = entity.records?.map((v) => v.toJson()).toList();
  data['total'] = entity.total;
  data['size'] = entity.size;
  data['current'] = entity.current;
  data['pages'] = entity.pages;
  return data;
}

extension ConversationEntityExtension on ConversationEntity {
  ConversationEntity copyWith({
    List<ConversationRecords>? records,
    int? total,
    int? size,
    int? current,
    int? pages,
  }) {
    return ConversationEntity()
      ..records = records ?? this.records
      ..total = total ?? this.total
      ..size = size ?? this.size
      ..current = current ?? this.current
      ..pages = pages ?? this.pages;
  }
}

ConversationRecords $ConversationRecordsFromJson(Map<String, dynamic> json) {
  final ConversationRecords conversationRecords = ConversationRecords();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    conversationRecords.id = id;
  }
  final String? avatar = jsonConvert.convert<String>(json['avatar']);
  if (avatar != null) {
    conversationRecords.avatar = avatar;
  }
  final String? userId = jsonConvert.convert<String>(json['user_id']);
  if (userId != null) {
    conversationRecords.userId = userId;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    conversationRecords.title = title;
  }
  final bool? pinned = jsonConvert.convert<bool>(json['pinned']);
  if (pinned != null) {
    conversationRecords.pinned = pinned;
  }
  final dynamic pinnedTime = json['pinned_time'];
  if (pinnedTime != null) {
    conversationRecords.pinnedTime = pinnedTime;
  }
  final String? characterId = jsonConvert.convert<String>(json['character_id']);
  if (characterId != null) {
    conversationRecords.characterId = characterId;
  }
  final dynamic model = json['model'];
  if (model != null) {
    conversationRecords.model = model;
  }
  final int? templateId = jsonConvert.convert<int>(json['template_id']);
  if (templateId != null) {
    conversationRecords.templateId = templateId;
  }
  final String? voiceModel = jsonConvert.convert<String>(json['voice_model']);
  if (voiceModel != null) {
    conversationRecords.voiceModel = voiceModel;
  }
  final dynamic lastMessage = json['last_message'];
  if (lastMessage != null) {
    conversationRecords.lastMessage = lastMessage;
  }
  final int? updateTime = jsonConvert.convert<int>(json['update_time']);
  if (updateTime != null) {
    conversationRecords.updateTime = updateTime;
  }
  final int? createTime = jsonConvert.convert<int>(json['create_time']);
  if (createTime != null) {
    conversationRecords.createTime = createTime;
  }
  final bool? collect = jsonConvert.convert<bool>(json['collect']);
  if (collect != null) {
    conversationRecords.collect = collect;
  }
  final ConversationRecordsUserChatLevel? userChatLevel = jsonConvert.convert<
      ConversationRecordsUserChatLevel>(json['user_chat_level']);
  if (userChatLevel != null) {
    conversationRecords.userChatLevel = userChatLevel;
  }
  final String? mode = jsonConvert.convert<String>(json['mode']);
  if (mode != null) {
    conversationRecords.mode = mode;
  }
  final String? background = jsonConvert.convert<String>(json['background']);
  if (background != null) {
    conversationRecords.background = background;
  }
  final int? cid = jsonConvert.convert<int>(json['cid']);
  if (cid != null) {
    conversationRecords.cid = cid;
  }
  final String? scene = jsonConvert.convert<String>(json['scene']);
  if (scene != null) {
    conversationRecords.scene = scene;
  }
  final String? profileId = jsonConvert.convert<String>(json['profile_id']);
  if (profileId != null) {
    conversationRecords.profileId = profileId;
  }
  final String? chatModel = jsonConvert.convert<String>(json['chat_model']);
  if (chatModel != null) {
    conversationRecords.chatModel = chatModel;
  }
  final String? languageCode = jsonConvert.convert<String>(
      json['language_code']);
  if (languageCode != null) {
    conversationRecords.languageCode = languageCode;
  }
  return conversationRecords;
}

Map<String, dynamic> $ConversationRecordsToJson(ConversationRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['avatar'] = entity.avatar;
  data['user_id'] = entity.userId;
  data['title'] = entity.title;
  data['pinned'] = entity.pinned;
  data['pinned_time'] = entity.pinnedTime;
  data['character_id'] = entity.characterId;
  data['model'] = entity.model;
  data['template_id'] = entity.templateId;
  data['voice_model'] = entity.voiceModel;
  data['last_message'] = entity.lastMessage;
  data['update_time'] = entity.updateTime;
  data['create_time'] = entity.createTime;
  data['collect'] = entity.collect;
  data['user_chat_level'] = entity.userChatLevel?.toJson();
  data['mode'] = entity.mode;
  data['background'] = entity.background;
  data['cid'] = entity.cid;
  data['scene'] = entity.scene;
  data['profile_id'] = entity.profileId;
  data['chat_model'] = entity.chatModel;
  data['language_code'] = entity.languageCode;
  return data;
}

extension ConversationRecordsExtension on ConversationRecords {
  ConversationRecords copyWith({
    String? id,
    String? avatar,
    String? userId,
    String? title,
    bool? pinned,
    dynamic pinnedTime,
    String? characterId,
    dynamic model,
    int? templateId,
    String? voiceModel,
    dynamic lastMessage,
    int? updateTime,
    int? createTime,
    bool? collect,
    ConversationRecordsUserChatLevel? userChatLevel,
    String? mode,
    String? background,
    int? cid,
    String? scene,
    String? profileId,
    String? chatModel,
    String? languageCode,
  }) {
    return ConversationRecords()
      ..id = id ?? this.id
      ..avatar = avatar ?? this.avatar
      ..userId = userId ?? this.userId
      ..title = title ?? this.title
      ..pinned = pinned ?? this.pinned
      ..pinnedTime = pinnedTime ?? this.pinnedTime
      ..characterId = characterId ?? this.characterId
      ..model = model ?? this.model
      ..templateId = templateId ?? this.templateId
      ..voiceModel = voiceModel ?? this.voiceModel
      ..lastMessage = lastMessage ?? this.lastMessage
      ..updateTime = updateTime ?? this.updateTime
      ..createTime = createTime ?? this.createTime
      ..collect = collect ?? this.collect
      ..userChatLevel = userChatLevel ?? this.userChatLevel
      ..mode = mode ?? this.mode
      ..background = background ?? this.background
      ..cid = cid ?? this.cid
      ..scene = scene ?? this.scene
      ..profileId = profileId ?? this.profileId
      ..chatModel = chatModel ?? this.chatModel
      ..languageCode = languageCode ?? this.languageCode;
  }
}

ConversationRecordsUserChatLevel $ConversationRecordsUserChatLevelFromJson(
    Map<String, dynamic> json) {
  final ConversationRecordsUserChatLevel conversationRecordsUserChatLevel = ConversationRecordsUserChatLevel();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    conversationRecordsUserChatLevel.id = id;
  }
  final String? userId = jsonConvert.convert<String>(json['user_id']);
  if (userId != null) {
    conversationRecordsUserChatLevel.userId = userId;
  }
  final int? conversationId = jsonConvert.convert<int>(json['conversation_id']);
  if (conversationId != null) {
    conversationRecordsUserChatLevel.conversationId = conversationId;
  }
  final String? charId = jsonConvert.convert<String>(json['char_id']);
  if (charId != null) {
    conversationRecordsUserChatLevel.charId = charId;
  }
  final int? level = jsonConvert.convert<int>(json['level']);
  if (level != null) {
    conversationRecordsUserChatLevel.level = level;
  }
  final int? num = jsonConvert.convert<int>(json['num']);
  if (num != null) {
    conversationRecordsUserChatLevel.num = num;
  }
  final double? progress = jsonConvert.convert<double>(json['progress']);
  if (progress != null) {
    conversationRecordsUserChatLevel.progress = progress;
  }
  final double? upgradeRequirements = jsonConvert.convert<double>(
      json['upgrade_requirements']);
  if (upgradeRequirements != null) {
    conversationRecordsUserChatLevel.upgradeRequirements = upgradeRequirements;
  }
  final int? rewards = jsonConvert.convert<int>(json['rewards']);
  if (rewards != null) {
    conversationRecordsUserChatLevel.rewards = rewards;
  }
  return conversationRecordsUserChatLevel;
}

Map<String, dynamic> $ConversationRecordsUserChatLevelToJson(
    ConversationRecordsUserChatLevel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['user_id'] = entity.userId;
  data['conversation_id'] = entity.conversationId;
  data['char_id'] = entity.charId;
  data['level'] = entity.level;
  data['num'] = entity.num;
  data['progress'] = entity.progress;
  data['upgrade_requirements'] = entity.upgradeRequirements;
  data['rewards'] = entity.rewards;
  return data;
}

extension ConversationRecordsUserChatLevelExtension on ConversationRecordsUserChatLevel {
  ConversationRecordsUserChatLevel copyWith({
    int? id,
    String? userId,
    int? conversationId,
    String? charId,
    int? level,
    int? num,
    double? progress,
    double? upgradeRequirements,
    int? rewards,
  }) {
    return ConversationRecordsUserChatLevel()
      ..id = id ?? this.id
      ..userId = userId ?? this.userId
      ..conversationId = conversationId ?? this.conversationId
      ..charId = charId ?? this.charId
      ..level = level ?? this.level
      ..num = num ?? this.num
      ..progress = progress ?? this.progress
      ..upgradeRequirements = upgradeRequirements ?? this.upgradeRequirements
      ..rewards = rewards ?? this.rewards;
  }
}