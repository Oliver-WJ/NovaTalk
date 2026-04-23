import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/user_entity.dart';

UserEntity $UserEntityFromJson(Map<String, dynamic> json) {
  final UserEntity userEntity = UserEntity();
  final String? id = jsonConvert.convert<String>(json['id']);
  if (id != null) {
    userEntity.id = id;
  }
  final String? deviceId = jsonConvert.convert<String>(json['device_id']);
  if (deviceId != null) {
    userEntity.deviceId = deviceId;
  }
  final dynamic token = json['token'];
  if (token != null) {
    userEntity.token = token;
  }
  final String? platform = jsonConvert.convert<String>(json['platform']);
  if (platform != null) {
    userEntity.platform = platform;
  }
  final int? gems = jsonConvert.convert<int>(json['gems']);
  if (gems != null) {
    userEntity.gems = gems;
  }
  final bool? audioSwitch = jsonConvert.convert<bool>(json['audio_switch']);
  if (audioSwitch != null) {
    userEntity.audioSwitch = audioSwitch;
  }
  final dynamic subscriptionEnd = json['subscription_end'];
  if (subscriptionEnd != null) {
    userEntity.subscriptionEnd = subscriptionEnd;
  }
  final String? nickname = jsonConvert.convert<String>(json['nickname']);
  if (nickname != null) {
    userEntity.nickname = nickname;
  }
  final dynamic idfa = json['idfa'];
  if (idfa != null) {
    userEntity.idfa = idfa;
  }
  final dynamic adid = json['adid'];
  if (adid != null) {
    userEntity.adid = adid;
  }
  final dynamic androidId = json['android_id'];
  if (androidId != null) {
    userEntity.androidId = androidId;
  }
  final dynamic gpsAdid = json['gps_adid'];
  if (gpsAdid != null) {
    userEntity.gpsAdid = gpsAdid;
  }
  final bool? autoTranslate = jsonConvert.convert<bool>(json['auto_translate']);
  if (autoTranslate != null) {
    userEntity.autoTranslate = autoTranslate;
  }
  final bool? enableAutoTranslate = jsonConvert.convert<bool>(
      json['enable_auto_translate']);
  if (enableAutoTranslate != null) {
    userEntity.enableAutoTranslate = enableAutoTranslate;
  }
  final String? sourceLanguage = jsonConvert.convert<String>(
      json['source_language']);
  if (sourceLanguage != null) {
    userEntity.sourceLanguage = sourceLanguage;
  }
  final String? targetLanguage = jsonConvert.convert<String>(
      json['target_language']);
  if (targetLanguage != null) {
    userEntity.targetLanguage = targetLanguage;
  }
  final dynamic sign = json['sign'];
  if (sign != null) {
    userEntity.sign = sign;
  }
  final dynamic freeMessage = json['free_message'];
  if (freeMessage != null) {
    userEntity.freeMessage = freeMessage;
  }
  final dynamic visual = json['visual'];
  if (visual != null) {
    userEntity.visual = visual;
  }
  final dynamic email = json['email'];
  if (email != null) {
    userEntity.email = email;
  }
  final bool? activate = jsonConvert.convert<bool>(json['activate']);
  if (activate != null) {
    userEntity.activate = activate;
  }
  final bool? pay = jsonConvert.convert<bool>(json['pay']);
  if (pay != null) {
    userEntity.pay = pay;
  }
  final int? undressCount = jsonConvert.convert<int>(json['undress_count']);
  if (undressCount != null) {
    userEntity.undressCount = undressCount;
  }
  final int? createImg = jsonConvert.convert<int>(json['create_img']);
  if (createImg != null) {
    userEntity.createImg = createImg;
  }
  final int? createVideo = jsonConvert.convert<int>(json['create_video']);
  if (createVideo != null) {
    userEntity.createVideo = createVideo;
  }
  final bool? videoUnlock = jsonConvert.convert<bool>(json['video_unlock']);
  if (videoUnlock != null) {
    userEntity.videoUnlock = videoUnlock;
  }
  final bool? old = jsonConvert.convert<bool>(json['old']);
  if (old != null) {
    userEntity.old = old;
  }
  final dynamic vip = json['vip'];
  if (vip != null) {
    userEntity.vip = vip;
  }
  final String? platformName = jsonConvert.convert<String>(
      json['platform_name']);
  if (platformName != null) {
    userEntity.platformName = platformName;
  }
  return userEntity;
}

Map<String, dynamic> $UserEntityToJson(UserEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['device_id'] = entity.deviceId;
  data['token'] = entity.token;
  data['platform'] = entity.platform;
  data['gems'] = entity.gems;
  data['audio_switch'] = entity.audioSwitch;
  data['subscription_end'] = entity.subscriptionEnd;
  data['nickname'] = entity.nickname;
  data['idfa'] = entity.idfa;
  data['adid'] = entity.adid;
  data['android_id'] = entity.androidId;
  data['gps_adid'] = entity.gpsAdid;
  data['auto_translate'] = entity.autoTranslate;
  data['enable_auto_translate'] = entity.enableAutoTranslate;
  data['source_language'] = entity.sourceLanguage;
  data['target_language'] = entity.targetLanguage;
  data['sign'] = entity.sign;
  data['free_message'] = entity.freeMessage;
  data['visual'] = entity.visual;
  data['email'] = entity.email;
  data['activate'] = entity.activate;
  data['pay'] = entity.pay;
  data['undress_count'] = entity.undressCount;
  data['create_img'] = entity.createImg;
  data['create_video'] = entity.createVideo;
  data['video_unlock'] = entity.videoUnlock;
  data['old'] = entity.old;
  data['vip'] = entity.vip;
  data['platform_name'] = entity.platformName;
  return data;
}

extension UserEntityExtension on UserEntity {
  UserEntity copyWith({
    String? id,
    String? deviceId,
    dynamic token,
    String? platform,
    int? gems,
    bool? audioSwitch,
    dynamic subscriptionEnd,
    String? nickname,
    dynamic idfa,
    dynamic adid,
    dynamic androidId,
    dynamic gpsAdid,
    bool? autoTranslate,
    bool? enableAutoTranslate,
    String? sourceLanguage,
    String? targetLanguage,
    dynamic sign,
    dynamic freeMessage,
    dynamic visual,
    dynamic email,
    bool? activate,
    bool? pay,
    int? undressCount,
    int? createImg,
    int? createVideo,
    bool? videoUnlock,
    bool? old,
    dynamic vip,
    String? platformName,
  }) {
    return UserEntity()
      ..id = id ?? this.id
      ..deviceId = deviceId ?? this.deviceId
      ..token = token ?? this.token
      ..platform = platform ?? this.platform
      ..gems = gems ?? this.gems
      ..audioSwitch = audioSwitch ?? this.audioSwitch
      ..subscriptionEnd = subscriptionEnd ?? this.subscriptionEnd
      ..nickname = nickname ?? this.nickname
      ..idfa = idfa ?? this.idfa
      ..adid = adid ?? this.adid
      ..androidId = androidId ?? this.androidId
      ..gpsAdid = gpsAdid ?? this.gpsAdid
      ..autoTranslate = autoTranslate ?? this.autoTranslate
      ..enableAutoTranslate = enableAutoTranslate ?? this.enableAutoTranslate
      ..sourceLanguage = sourceLanguage ?? this.sourceLanguage
      ..targetLanguage = targetLanguage ?? this.targetLanguage
      ..sign = sign ?? this.sign
      ..freeMessage = freeMessage ?? this.freeMessage
      ..visual = visual ?? this.visual
      ..email = email ?? this.email
      ..activate = activate ?? this.activate
      ..pay = pay ?? this.pay
      ..undressCount = undressCount ?? this.undressCount
      ..createImg = createImg ?? this.createImg
      ..createVideo = createVideo ?? this.createVideo
      ..videoUnlock = videoUnlock ?? this.videoUnlock
      ..old = old ?? this.old
      ..vip = vip ?? this.vip
      ..platformName = platformName ?? this.platformName;
  }
}