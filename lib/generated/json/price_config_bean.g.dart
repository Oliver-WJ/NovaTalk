import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/price_config_bean.dart';

PriceConfigBean $PriceConfigBeanFromJson(Map<String, dynamic> json) {
  final PriceConfigBean priceConfigBean = PriceConfigBean();
  final int? sceneChange = jsonConvert.convert<int>(json['scene_change']);
  if (sceneChange != null) {
    priceConfigBean.sceneChange = sceneChange;
  }
  final int? textMessage = jsonConvert.convert<int>(json['text_message']);
  if (textMessage != null) {
    priceConfigBean.textMessage = textMessage;
  }
  final int? audioMessage = jsonConvert.convert<int>(json['audio_message']);
  if (audioMessage != null) {
    priceConfigBean.audioMessage = audioMessage;
  }
  final int? photoMessage = jsonConvert.convert<int>(json['photo_message']);
  if (photoMessage != null) {
    priceConfigBean.photoMessage = photoMessage;
  }
  final int? videoMessage = jsonConvert.convert<int>(json['video_message']);
  if (videoMessage != null) {
    priceConfigBean.videoMessage = videoMessage;
  }
  final int? generateImage = jsonConvert.convert<int>(json['generate_image']);
  if (generateImage != null) {
    priceConfigBean.generateImage = generateImage;
  }
  final int? generateVideo = jsonConvert.convert<int>(json['generate_video']);
  if (generateVideo != null) {
    priceConfigBean.generateVideo = generateVideo;
  }
  final int? profileChange = jsonConvert.convert<int>(json['profile_change']);
  if (profileChange != null) {
    priceConfigBean.profileChange = profileChange;
  }
  final int? callAiCharacters = jsonConvert.convert<int>(
      json['call_ai_characters']);
  if (callAiCharacters != null) {
    priceConfigBean.callAiCharacters = callAiCharacters;
  }
  return priceConfigBean;
}

Map<String, dynamic> $PriceConfigBeanToJson(PriceConfigBean entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['scene_change'] = entity.sceneChange;
  data['text_message'] = entity.textMessage;
  data['audio_message'] = entity.audioMessage;
  data['photo_message'] = entity.photoMessage;
  data['video_message'] = entity.videoMessage;
  data['generate_image'] = entity.generateImage;
  data['generate_video'] = entity.generateVideo;
  data['profile_change'] = entity.profileChange;
  data['call_ai_characters'] = entity.callAiCharacters;
  return data;
}

extension PriceConfigBeanExtension on PriceConfigBean {
  PriceConfigBean copyWith({
    int? sceneChange,
    int? textMessage,
    int? audioMessage,
    int? photoMessage,
    int? videoMessage,
    int? generateImage,
    int? generateVideo,
    int? profileChange,
    int? callAiCharacters,
  }) {
    return PriceConfigBean()
      ..sceneChange = sceneChange ?? this.sceneChange
      ..textMessage = textMessage ?? this.textMessage
      ..audioMessage = audioMessage ?? this.audioMessage
      ..photoMessage = photoMessage ?? this.photoMessage
      ..videoMessage = videoMessage ?? this.videoMessage
      ..generateImage = generateImage ?? this.generateImage
      ..generateVideo = generateVideo ?? this.generateVideo
      ..profileChange = profileChange ?? this.profileChange
      ..callAiCharacters = callAiCharacters ?? this.callAiCharacters;
  }
}