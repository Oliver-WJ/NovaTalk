import 'package:novatalk/generated/json/base/json_convert_content.dart';
import 'package:novatalk/app/entities/msg_clothing.dart';

ChangeClothe $ChangeClotheFromJson(Map<String, dynamic> json) {
  final ChangeClothe changeClothe = ChangeClothe();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    changeClothe.id = id;
  }
  final int? clothingType = jsonConvert.convert<int>(json['clothingType']);
  if (clothingType != null) {
    changeClothe.clothingType = clothingType;
  }
  final String? modelId = jsonConvert.convert<String>(json['modelId']);
  if (modelId != null) {
    changeClothe.modelId = modelId;
  }
  return changeClothe;
}

Map<String, dynamic> $ChangeClotheToJson(ChangeClothe entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['clothingType'] = entity.clothingType;
  data['modelId'] = entity.modelId;
  return data;
}

extension ChangeClotheExtension on ChangeClothe {
  ChangeClothe copyWith({
    int? id,
    int? clothingType,
    String? modelId,
  }) {
    return ChangeClothe()
      ..id = id ?? this.id
      ..clothingType = clothingType ?? this.clothingType
      ..modelId = modelId ?? this.modelId;
  }
}