import 'dart:convert';

import '../../generated/json/base/json_field.dart';

@JsonSerializable()
class CharacterVideoChat {
   int? id;
   String? characterId;
   String? tag;
   int? duration;
   String? url;
   String? gifUrl;

  CharacterVideoChat({
    this.id,
    this.characterId,
    this.tag,
    this.duration,
    this.url,
    this.gifUrl,
  });

  factory CharacterVideoChat.fromRawJson(String str) =>
      CharacterVideoChat.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());


  factory CharacterVideoChat.fromJson(Map<String, dynamic> json) =>
      CharacterVideoChat(
        id: json['id'],
        characterId: json['character_id'],
        tag: json['tag'],
        duration: json['duration'],
        url: json['url'],
        gifUrl: json['gif_url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'character_id': characterId,
        'tag': tag,
        'duration': duration,
        'url': url,
        'gif_url': gifUrl,
      };
}
