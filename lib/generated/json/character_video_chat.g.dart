import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/character_video_chat.dart';

CharacterVideoChat $CharacterVideoChatFromJson(Map<String, dynamic> json) {
  final CharacterVideoChat characterVideoChat = CharacterVideoChat();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    characterVideoChat.id = id;
  }
  final String? characterId = jsonConvert.convert<String>(json['characterId']);
  if (characterId != null) {
    characterVideoChat.characterId = characterId;
  }
  final String? tag = jsonConvert.convert<String>(json['tag']);
  if (tag != null) {
    characterVideoChat.tag = tag;
  }
  final int? duration = jsonConvert.convert<int>(json['duration']);
  if (duration != null) {
    characterVideoChat.duration = duration;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    characterVideoChat.url = url;
  }
  final String? gifUrl = jsonConvert.convert<String>(json['gifUrl']);
  if (gifUrl != null) {
    characterVideoChat.gifUrl = gifUrl;
  }
  return characterVideoChat;
}

Map<String, dynamic> $CharacterVideoChatToJson(CharacterVideoChat entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['characterId'] = entity.characterId;
  data['tag'] = entity.tag;
  data['duration'] = entity.duration;
  data['url'] = entity.url;
  data['gifUrl'] = entity.gifUrl;
  return data;
}

extension CharacterVideoChatExtension on CharacterVideoChat {
  CharacterVideoChat copyWith({
    int? id,
    String? characterId,
    String? tag,
    int? duration,
    String? url,
    String? gifUrl,
  }) {
    return CharacterVideoChat()
      ..id = id ?? this.id
      ..characterId = characterId ?? this.characterId
      ..tag = tag ?? this.tag
      ..duration = duration ?? this.duration
      ..url = url ?? this.url
      ..gifUrl = gifUrl ?? this.gifUrl;
  }
}