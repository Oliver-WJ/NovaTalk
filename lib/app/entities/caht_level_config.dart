import 'dart:convert';

class ChatLevelConfig {
  final int? id;
  final int? level;
  final int? reward;
  final String? title;

  ChatLevelConfig({
    this.id,
    this.level,
    this.reward,
    this.title,
  });

  factory ChatLevelConfig.fromRawJson(String str) => ChatLevelConfig.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ChatLevelConfig.fromJson(Map<String, dynamic> json) => ChatLevelConfig(
        id: json['id'],
        level: json['level'],
        reward: json['reward'],
        title: json['title'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'level': level,
        'reward': reward,
        'title': title,
      };
}
