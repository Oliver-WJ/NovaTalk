import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/role_entity.dart';
import 'package:novatalk/app/entities/character_video_chat.dart';

import 'package:novatalk/app/entities/msg_clothing.dart';


RoleEntity $RoleEntityFromJson(Map<String, dynamic> json) {
  final RoleEntity roleEntity = RoleEntity();
  final List<RoleRecords>? records = (json['records'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<RoleRecords>(e) as RoleRecords).toList();
  if (records != null) {
    roleEntity.records = records;
  }
  final int? total = jsonConvert.convert<int>(json['total']);
  if (total != null) {
    roleEntity.total = total;
  }
  final int? size = jsonConvert.convert<int>(json['size']);
  if (size != null) {
    roleEntity.size = size;
  }
  final int? current = jsonConvert.convert<int>(json['current']);
  if (current != null) {
    roleEntity.current = current;
  }
  final int? pages = jsonConvert.convert<int>(json['pages']);
  if (pages != null) {
    roleEntity.pages = pages;
  }
  return roleEntity;
}

Map<String, dynamic> $RoleEntityToJson(RoleEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['records'] = entity.records?.map((v) => v.toJson()).toList();
  data['total'] = entity.total;
  data['size'] = entity.size;
  data['current'] = entity.current;
  data['pages'] = entity.pages;
  return data;
}

extension RoleEntityExtension on RoleEntity {
  RoleEntity copyWith({
    List<RoleRecords>? records,
    int? total,
    int? size,
    int? current,
    int? pages,
  }) {
    return RoleEntity()
      ..records = records ?? this.records
      ..total = total ?? this.total
      ..size = size ?? this.size
      ..current = current ?? this.current
      ..pages = pages ?? this.pages;
  }
}

RoleRecords $RoleRecordsFromJson(Map<String, dynamic> json) {
  final RoleRecords roleRecords = RoleRecords();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    roleRecords.id = id;
  }
  final int? age = jsonConvert.convert<int>(json['age']);
  if (age != null) {
    roleRecords.age = age;
  }
  final String? aboutMe = jsonConvert.convert<String>(json['about_me']);
  if (aboutMe != null) {
    roleRecords.aboutMe = aboutMe;
  }
  final RoleRecordsMedia? media = jsonConvert.convert<RoleRecordsMedia>(
      json['media']);
  if (media != null) {
    roleRecords.media = media;
  }
  final List<RoleRecordsImages>? images = (json['images'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<RoleRecordsImages>(e) as RoleRecordsImages)
      .toList();
  if (images != null) {
    roleRecords.images = images;
  }
  final String? avatar = jsonConvert.convert<String>(json['avatar']);
  if (avatar != null) {
    roleRecords.avatar = avatar;
  }
  final String? avatarVideo = jsonConvert.convert<String>(json['avatar_video']);
  if (avatarVideo != null) {
    roleRecords.avatarVideo = avatarVideo;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    roleRecords.name = name;
  }
  final String? platform = jsonConvert.convert<String>(json['platform']);
  if (platform != null) {
    roleRecords.platform = platform;
  }
  final String? renderStyle = jsonConvert.convert<String>(json['render_style']);
  if (renderStyle != null) {
    roleRecords.renderStyle = renderStyle;
  }
  final String? likes = jsonConvert.convert<String>(json['likes']);
  if (likes != null) {
    roleRecords.likes = likes;
  }
  final List<String>? greetings = (json['greetings'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (greetings != null) {
    roleRecords.greetings = greetings;
  }
  final List<GreetingsVoice>? greetingsVoice = (json['greetings_voice'] as List<
      dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<GreetingsVoice>(e) as GreetingsVoice)
      .toList();
  if (greetingsVoice != null) {
    roleRecords.greetingsVoice = greetingsVoice;
  }
  final String? sessionCount = jsonConvert.convert<String>(
      json['session_count']);
  if (sessionCount != null) {
    roleRecords.sessionCount = sessionCount;
  }
  final bool? vip = jsonConvert.convert<bool>(json['vip']);
  if (vip != null) {
    roleRecords.vip = vip;
  }
  final int? orderNum = jsonConvert.convert<int>(json['order_num']);
  if (orderNum != null) {
    roleRecords.orderNum = orderNum;
  }
  final List<String>? tags = (json['tags'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (tags != null) {
    roleRecords.tags = tags;
  }
  final String? tagType = jsonConvert.convert<String>(json['tag_type']);
  if (tagType != null) {
    roleRecords.tagType = tagType;
  }
  final String? scenario = jsonConvert.convert<String>(json['scenario']);
  if (scenario != null) {
    roleRecords.scenario = scenario;
  }
  final double? temperature = jsonConvert.convert<double>(json['temperature']);
  if (temperature != null) {
    roleRecords.temperature = temperature;
  }
  final String? voiceId = jsonConvert.convert<String>(json['voice_id']);
  if (voiceId != null) {
    roleRecords.voiceId = voiceId;
  }
  final String? engine = jsonConvert.convert<String>(json['engine']);
  if (engine != null) {
    roleRecords.engine = engine;
  }
  final int? gender = jsonConvert.convert<int>(json['gender']);
  if (gender != null) {
    roleRecords.gender = gender;
  }
  final bool? videoChat = jsonConvert.convert<bool>(json['video_chat']);
  if (videoChat != null) {
    roleRecords.videoChat = videoChat;
  }
  final List<
      CharacterVideoChat>? characterVideoChat = (json['character_video_chat'] as List<
      dynamic>?)
      ?.map(
          (e) =>
      jsonConvert.convert<CharacterVideoChat>(e) as CharacterVideoChat)
      .toList();
  if (characterVideoChat != null) {
    roleRecords.characterVideoChat = characterVideoChat;
  }
  final List<String>? genPhotoTags = (json['gen_photo_tags'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<String>(e) as String)
      .toList();
  if (genPhotoTags != null) {
    roleRecords.genPhotoTags = genPhotoTags;
  }
  final List<String>? genVideoTags = (json['gen_video_tags'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<String>(e) as String)
      .toList();
  if (genVideoTags != null) {
    roleRecords.genVideoTags = genVideoTags;
  }
  final bool? genPhoto = jsonConvert.convert<bool>(json['gen_photo']);
  if (genPhoto != null) {
    roleRecords.genPhoto = genPhoto;
  }
  final bool? genVideo = jsonConvert.convert<bool>(json['gen_video']);
  if (genVideo != null) {
    roleRecords.genVideo = genVideo;
  }
  final bool? gems = jsonConvert.convert<bool>(json['gems']);
  if (gems != null) {
    roleRecords.gems = gems;
  }
  final bool? collect = jsonConvert.convert<bool>(json['collect']);
  if (collect != null) {
    roleRecords.collect = collect;
  }
  final String? lastMessage = jsonConvert.convert<String>(json['last_message']);
  if (lastMessage != null) {
    roleRecords.lastMessage = lastMessage;
  }
  final String? intro = jsonConvert.convert<String>(json['intro']);
  if (intro != null) {
    roleRecords.intro = intro;
  }
  final bool? changeClothing = jsonConvert.convert<bool>(
      json['change_clothing']);
  if (changeClothing != null) {
    roleRecords.changeClothing = changeClothing;
  }
  final List<ChangeClothe>? changeClothes = (json['change_clothes'] as List<
      dynamic>?)?.map(
          (e) => jsonConvert.convert<ChangeClothe>(e) as ChangeClothe).toList();
  if (changeClothes != null) {
    roleRecords.changeClothes = changeClothes;
  }
  final String? updateTime = jsonConvert.convert<String>(json['update_time']);
  if (updateTime != null) {
    roleRecords.updateTime = updateTime;
  }
  final int? chatNum = jsonConvert.convert<int>(json['chat_num']);
  if (chatNum != null) {
    roleRecords.chatNum = chatNum;
  }
  final int? msgNum = jsonConvert.convert<int>(json['msg_num']);
  if (msgNum != null) {
    roleRecords.msgNum = msgNum;
  }
  final String? mode = jsonConvert.convert<String>(json['mode']);
  if (mode != null) {
    roleRecords.mode = mode;
  }
  final int? cid = jsonConvert.convert<int>(json['cid']);
  if (cid != null) {
    roleRecords.cid = cid;
  }
  final String? characterOrigin = jsonConvert.convert<String>(
      json['character_origin']);
  if (characterOrigin != null) {
    roleRecords.characterOrigin = characterOrigin;
  }
  final String? origin = jsonConvert.convert<String>(json['origin']);
  if (origin != null) {
    roleRecords.origin = origin;
  }
  final int? cardNum = jsonConvert.convert<int>(json['card_num']);
  if (cardNum != null) {
    roleRecords.cardNum = cardNum;
  }
  final int? unlockCardNum = jsonConvert.convert<int>(json['unlock_card_num']);
  if (unlockCardNum != null) {
    roleRecords.unlockCardNum = unlockCardNum;
  }
  final int? price = jsonConvert.convert<int>(json['price']);
  if (price != null) {
    roleRecords.price = price;
  }
  final String? createUserId = jsonConvert.convert<String>(
      json['create_user_id']);
  if (createUserId != null) {
    roleRecords.createUserId = createUserId;
  }
  final String? createUserName = jsonConvert.convert<String>(
      json['create_user_name']);
  if (createUserName != null) {
    roleRecords.createUserName = createUserName;
  }
  final String? auditStatus = jsonConvert.convert<String>(json['audit_status']);
  if (auditStatus != null) {
    roleRecords.auditStatus = auditStatus;
  }
  return roleRecords;
}

Map<String, dynamic> $RoleRecordsToJson(RoleRecords entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['age'] = entity.age;
  data['about_me'] = entity.aboutMe;
  data['media'] = entity.media?.toJson();
  data['images'] = entity.images?.map((v) => v.toJson()).toList();
  data['avatar'] = entity.avatar;
  data['avatar_video'] = entity.avatarVideo;
  data['name'] = entity.name;
  data['platform'] = entity.platform;
  data['render_style'] = entity.renderStyle;
  data['likes'] = entity.likes;
  data['greetings'] = entity.greetings;
  data['greetings_voice'] =
      entity.greetingsVoice?.map((v) => v.toJson()).toList();
  data['session_count'] = entity.sessionCount;
  data['vip'] = entity.vip;
  data['order_num'] = entity.orderNum;
  data['tags'] = entity.tags;
  data['tag_type'] = entity.tagType;
  data['scenario'] = entity.scenario;
  data['temperature'] = entity.temperature;
  data['voice_id'] = entity.voiceId;
  data['engine'] = entity.engine;
  data['gender'] = entity.gender;
  data['video_chat'] = entity.videoChat;
  data['character_video_chat'] =
      entity.characterVideoChat?.map((v) => v.toJson()).toList();
  data['gen_photo_tags'] = entity.genPhotoTags;
  data['gen_video_tags'] = entity.genVideoTags;
  data['gen_photo'] = entity.genPhoto;
  data['gen_video'] = entity.genVideo;
  data['gems'] = entity.gems;
  data['collect'] = entity.collect;
  data['last_message'] = entity.lastMessage;
  data['intro'] = entity.intro;
  data['change_clothing'] = entity.changeClothing;
  data['change_clothes'] =
      entity.changeClothes?.map((v) => v.toJson()).toList();
  data['update_time'] = entity.updateTime;
  data['chat_num'] = entity.chatNum;
  data['msg_num'] = entity.msgNum;
  data['mode'] = entity.mode;
  data['cid'] = entity.cid;
  data['character_origin'] = entity.characterOrigin;
  data['origin'] = entity.origin;
  data['card_num'] = entity.cardNum;
  data['unlock_card_num'] = entity.unlockCardNum;
  data['price'] = entity.price;
  data['create_user_id'] = entity.createUserId;
  data['create_user_name'] = entity.createUserName;
  data['audit_status'] = entity.auditStatus;
  return data;
}

extension RoleRecordsExtension on RoleRecords {
  RoleRecords copyWith({
    String? id,
    int? age,
    String? aboutMe,
    RoleRecordsMedia? media,
    List<RoleRecordsImages>? images,
    String? avatar,
    String? avatarVideo,
    String? name,
    String? platform,
    String? renderStyle,
    String? likes,
    List<String>? greetings,
    List<GreetingsVoice>? greetingsVoice,
    String? sessionCount,
    bool? vip,
    int? orderNum,
    List<String>? tags,
    String? tagType,
    String? scenario,
    double? temperature,
    String? voiceId,
    String? engine,
    int? gender,
    bool? videoChat,
    List<CharacterVideoChat>? characterVideoChat,
    List<String>? genPhotoTags,
    List<String>? genVideoTags,
    bool? genPhoto,
    bool? genVideo,
    bool? gems,
    bool? collect,
    String? lastMessage,
    String? intro,
    bool? changeClothing,
    List<ChangeClothe>? changeClothes,
    String? updateTime,
    int? chatNum,
    int? msgNum,
    String? mode,
    int? cid,
    String? characterOrigin,
    String? origin,
    int? cardNum,
    int? unlockCardNum,
    int? price,
    String? createUserId,
    String? createUserName,
    String? auditStatus,
  }) {
    return RoleRecords()
      ..id = id ?? this.id
      ..age = age ?? this.age
      ..aboutMe = aboutMe ?? this.aboutMe
      ..media = media ?? this.media
      ..images = images ?? this.images
      ..avatar = avatar ?? this.avatar
      ..avatarVideo = avatarVideo ?? this.avatarVideo
      ..name = name ?? this.name
      ..platform = platform ?? this.platform
      ..renderStyle = renderStyle ?? this.renderStyle
      ..likes = likes ?? this.likes
      ..greetings = greetings ?? this.greetings
      ..greetingsVoice = greetingsVoice ?? this.greetingsVoice
      ..sessionCount = sessionCount ?? this.sessionCount
      ..vip = vip ?? this.vip
      ..orderNum = orderNum ?? this.orderNum
      ..tags = tags ?? this.tags
      ..tagType = tagType ?? this.tagType
      ..scenario = scenario ?? this.scenario
      ..temperature = temperature ?? this.temperature
      ..voiceId = voiceId ?? this.voiceId
      ..engine = engine ?? this.engine
      ..gender = gender ?? this.gender
      ..videoChat = videoChat ?? this.videoChat
      ..characterVideoChat = characterVideoChat ?? this.characterVideoChat
      ..genPhotoTags = genPhotoTags ?? this.genPhotoTags
      ..genVideoTags = genVideoTags ?? this.genVideoTags
      ..genPhoto = genPhoto ?? this.genPhoto
      ..genVideo = genVideo ?? this.genVideo
      ..gems = gems ?? this.gems
      ..collect = collect ?? this.collect
      ..lastMessage = lastMessage ?? this.lastMessage
      ..intro = intro ?? this.intro
      ..changeClothing = changeClothing ?? this.changeClothing
      ..changeClothes = changeClothes ?? this.changeClothes
      ..updateTime = updateTime ?? this.updateTime
      ..chatNum = chatNum ?? this.chatNum
      ..msgNum = msgNum ?? this.msgNum
      ..mode = mode ?? this.mode
      ..cid = cid ?? this.cid
      ..characterOrigin = characterOrigin ?? this.characterOrigin
      ..origin = origin ?? this.origin
      ..cardNum = cardNum ?? this.cardNum
      ..unlockCardNum = unlockCardNum ?? this.unlockCardNum
      ..price = price ?? this.price
      ..createUserId = createUserId ?? this.createUserId
      ..createUserName = createUserName ?? this.createUserName
      ..auditStatus = auditStatus ?? this.auditStatus;
  }
}

GreetingsVoice $GreetingsVoiceFromJson(Map<String, dynamic> json) {
  final GreetingsVoice greetingsVoice = GreetingsVoice();
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    greetingsVoice.url = url;
  }
  final int? duration = jsonConvert.convert<int>(json['duration']);
  if (duration != null) {
    greetingsVoice.duration = duration;
  }
  return greetingsVoice;
}

Map<String, dynamic> $GreetingsVoiceToJson(GreetingsVoice entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['url'] = entity.url;
  data['duration'] = entity.duration;
  return data;
}

extension GreetingsVoiceExtension on GreetingsVoice {
  GreetingsVoice copyWith({
    String? url,
    int? duration,
  }) {
    return GreetingsVoice()
      ..url = url ?? this.url
      ..duration = duration ?? this.duration;
  }
}

RoleRecordsMedia $RoleRecordsMediaFromJson(Map<String, dynamic> json) {
  final RoleRecordsMedia roleRecordsMedia = RoleRecordsMedia();
  final List<String>? characterImages = (json['character_images'] as List<
      dynamic>?)?.map(
          (e) => jsonConvert.convert<String>(e) as String).toList();
  if (characterImages != null) {
    roleRecordsMedia.characterImages = characterImages;
  }
  return roleRecordsMedia;
}

Map<String, dynamic> $RoleRecordsMediaToJson(RoleRecordsMedia entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['character_images'] = entity.characterImages;
  return data;
}

extension RoleRecordsMediaExtension on RoleRecordsMedia {
  RoleRecordsMedia copyWith({
    List<String>? characterImages,
  }) {
    return RoleRecordsMedia()
      ..characterImages = characterImages ?? this.characterImages;
  }
}

RoleRecordsImages $RoleRecordsImagesFromJson(Map<String, dynamic> json) {
  final RoleRecordsImages roleRecordsImages = RoleRecordsImages();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    roleRecordsImages.id = id;
  }
  final dynamic createTime = json['create_time'];
  if (createTime != null) {
    roleRecordsImages.createTime = createTime;
  }
  final dynamic updateTime = json['update_time'];
  if (updateTime != null) {
    roleRecordsImages.updateTime = updateTime;
  }
  final String? imageUrl = jsonConvert.convert<String>(json['image_url']);
  if (imageUrl != null) {
    roleRecordsImages.imageUrl = imageUrl;
  }
  final String? modelId = jsonConvert.convert<String>(json['model_id']);
  if (modelId != null) {
    roleRecordsImages.modelId = modelId;
  }
  final int? gems = jsonConvert.convert<int>(json['gems']);
  if (gems != null) {
    roleRecordsImages.gems = gems;
  }
  final int? imgType = jsonConvert.convert<int>(json['img_type']);
  if (imgType != null) {
    roleRecordsImages.imgType = imgType;
  }
  final dynamic imgRemark = json['img_remark'];
  if (imgRemark != null) {
    roleRecordsImages.imgRemark = imgRemark;
  }
  final bool? unlocked = jsonConvert.convert<bool>(json['unlocked']);
  if (unlocked != null) {
    roleRecordsImages.unlocked = unlocked;
  }
  return roleRecordsImages;
}

Map<String, dynamic> $RoleRecordsImagesToJson(RoleRecordsImages entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['create_time'] = entity.createTime;
  data['update_time'] = entity.updateTime;
  data['image_url'] = entity.imageUrl;
  data['model_id'] = entity.modelId;
  data['gems'] = entity.gems;
  data['img_type'] = entity.imgType;
  data['img_remark'] = entity.imgRemark;
  data['unlocked'] = entity.unlocked;
  return data;
}

extension RoleRecordsImagesExtension on RoleRecordsImages {
  RoleRecordsImages copyWith({
    int? id,
    dynamic createTime,
    dynamic updateTime,
    String? imageUrl,
    String? modelId,
    int? gems,
    int? imgType,
    dynamic imgRemark,
    bool? unlocked,
  }) {
    return RoleRecordsImages()
      ..id = id ?? this.id
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime
      ..imageUrl = imageUrl ?? this.imageUrl
      ..modelId = modelId ?? this.modelId
      ..gems = gems ?? this.gems
      ..imgType = imgType ?? this.imgType
      ..imgRemark = imgRemark ?? this.imgRemark
      ..unlocked = unlocked ?? this.unlocked;
  }
}

RoleRecordsCharacterVideoChat $RoleRecordsCharacterVideoChatFromJson(
    Map<String, dynamic> json) {
  final RoleRecordsCharacterVideoChat roleRecordsCharacterVideoChat = RoleRecordsCharacterVideoChat();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    roleRecordsCharacterVideoChat.id = id;
  }
  final String? characterId = jsonConvert.convert<String>(json['character_id']);
  if (characterId != null) {
    roleRecordsCharacterVideoChat.characterId = characterId;
  }
  final String? tag = jsonConvert.convert<String>(json['tag']);
  if (tag != null) {
    roleRecordsCharacterVideoChat.tag = tag;
  }
  final int? duration = jsonConvert.convert<int>(json['duration']);
  if (duration != null) {
    roleRecordsCharacterVideoChat.duration = duration;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    roleRecordsCharacterVideoChat.url = url;
  }
  final String? gifUrl = jsonConvert.convert<String>(json['gif_url']);
  if (gifUrl != null) {
    roleRecordsCharacterVideoChat.gifUrl = gifUrl;
  }
  final dynamic createTime = json['create_time'];
  if (createTime != null) {
    roleRecordsCharacterVideoChat.createTime = createTime;
  }
  final dynamic updateTime = json['update_time'];
  if (updateTime != null) {
    roleRecordsCharacterVideoChat.updateTime = updateTime;
  }
  return roleRecordsCharacterVideoChat;
}

Map<String, dynamic> $RoleRecordsCharacterVideoChatToJson(
    RoleRecordsCharacterVideoChat entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['character_id'] = entity.characterId;
  data['tag'] = entity.tag;
  data['duration'] = entity.duration;
  data['url'] = entity.url;
  data['gif_url'] = entity.gifUrl;
  data['create_time'] = entity.createTime;
  data['update_time'] = entity.updateTime;
  return data;
}

extension RoleRecordsCharacterVideoChatExtension on RoleRecordsCharacterVideoChat {
  RoleRecordsCharacterVideoChat copyWith({
    int? id,
    String? characterId,
    String? tag,
    int? duration,
    String? url,
    String? gifUrl,
    dynamic createTime,
    dynamic updateTime,
  }) {
    return RoleRecordsCharacterVideoChat()
      ..id = id ?? this.id
      ..characterId = characterId ?? this.characterId
      ..tag = tag ?? this.tag
      ..duration = duration ?? this.duration
      ..url = url ?? this.url
      ..gifUrl = gifUrl ?? this.gifUrl
      ..createTime = createTime ?? this.createTime
      ..updateTime = updateTime ?? this.updateTime;
  }
}