import 'dart:convert';

class RoleImage {
  int? id;
  String? imageUrl;
  String? modelId;
  int? gemTally;
  bool? unlocked;

  RoleImage({
    this.id,
    this.imageUrl,
    this.modelId,
    this.gemTally,
    this.unlocked,
  });

  factory RoleImage.fromRawJson(String str) => RoleImage.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RoleImage.fromJson(Map<String, dynamic> json) => RoleImage(
    id: json['id'],
    imageUrl: json['image_url'],
    modelId: json['model_id'],
    gemTally: json['gem_bal'],
    unlocked: json['unlocked'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'image_url': imageUrl,
    'model_id': modelId,
    'gem_bal': gemTally,
    'unlocked': unlocked,
  };

  RoleImage copyWith({
    int? id,
    String? imageUrl,
    String? modelId,
    int? gemTally,
    bool? unlocked,
  }) {
    return RoleImage(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      modelId: modelId ?? this.modelId,
      gemTally: gemTally ?? this.gemTally,
      unlocked: unlocked ?? this.unlocked,
    );
  }
}
