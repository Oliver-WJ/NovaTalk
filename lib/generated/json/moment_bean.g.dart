import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/moment_bean.dart';

MomentBean $MomentBeanFromJson(Map<String, dynamic> json) {
  final MomentBean momentBean = MomentBean();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    momentBean.id = id;
  }
  final String? characterAvatar = jsonConvert.convert<String>(
      json['character_avatar']);
  if (characterAvatar != null) {
    momentBean.characterAvatar = characterAvatar;
  }
  final String? characterId = jsonConvert.convert<String>(json['character_id']);
  if (characterId != null) {
    momentBean.characterId = characterId;
  }
  final String? characterName = jsonConvert.convert<String>(
      json['character_name']);
  if (characterName != null) {
    momentBean.characterName = characterName;
  }
  final String? cover = jsonConvert.convert<String>(json['cover']);
  if (cover != null) {
    momentBean.cover = cover;
  }
  final dynamic createTime = json['create_time'];
  if (createTime != null) {
    momentBean.createTime = createTime;
  }
  final dynamic duration = json['duration'];
  if (duration != null) {
    momentBean.duration = duration;
  }
  final bool? hideCharacter = jsonConvert.convert<bool>(json['hide_character']);
  if (hideCharacter != null) {
    momentBean.hideCharacter = hideCharacter;
  }
  final bool? istop = jsonConvert.convert<bool>(json['istop']);
  if (istop != null) {
    momentBean.istop = istop;
  }
  final String? media = jsonConvert.convert<String>(json['media']);
  if (media != null) {
    momentBean.media = media;
  }
  final dynamic mediaText = json['media_text'];
  if (mediaText != null) {
    momentBean.mediaText = mediaText;
  }
  final String? text = jsonConvert.convert<String>(json['text']);
  if (text != null) {
    momentBean.text = text;
  }
  final dynamic updateTime = json['update_time'];
  if (updateTime != null) {
    momentBean.updateTime = updateTime;
  }
  final bool? unlocked = jsonConvert.convert<bool>(json['unlocked']);
  if (unlocked != null) {
    momentBean.unlocked = unlocked;
  }
  final int? price = jsonConvert.convert<int>(json['price']);
  if (price != null) {
    momentBean.price = price;
  }
  return momentBean;
}

Map<String, dynamic> $MomentBeanToJson(MomentBean entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['character_avatar'] = entity.characterAvatar;
  data['character_id'] = entity.characterId;
  data['character_name'] = entity.characterName;
  data['cover'] = entity.cover;
  data['create_time'] = entity.createTime;
  data['duration'] = entity.duration;
  data['hide_character'] = entity.hideCharacter;
  data['istop'] = entity.istop;
  data['media'] = entity.media;
  data['media_text'] = entity.mediaText;
  data['text'] = entity.text;
  data['update_time'] = entity.updateTime;
  data['unlocked'] = entity.unlocked;
  data['price'] = entity.price;
  return data;
}

extension MomentBeanExtension on MomentBean {
  MomentBean copyWith({
    int? id,
    String? characterAvatar,
    String? characterId,
    String? characterName,
    String? cover,
    dynamic createTime,
    dynamic duration,
    bool? hideCharacter,
    bool? istop,
    String? media,
    dynamic mediaText,
    String? text,
    dynamic updateTime,
    bool? unlocked,
    int? price,
  }) {
    return MomentBean()
      ..id = id ?? this.id
      ..characterAvatar = characterAvatar ?? this.characterAvatar
      ..characterId = characterId ?? this.characterId
      ..characterName = characterName ?? this.characterName
      ..cover = cover ?? this.cover
      ..createTime = createTime ?? this.createTime
      ..duration = duration ?? this.duration
      ..hideCharacter = hideCharacter ?? this.hideCharacter
      ..istop = istop ?? this.istop
      ..media = media ?? this.media
      ..mediaText = mediaText ?? this.mediaText
      ..text = text ?? this.text
      ..updateTime = updateTime ?? this.updateTime
      ..unlocked = unlocked ?? this.unlocked
      ..price = price ?? this.price;
  }
}