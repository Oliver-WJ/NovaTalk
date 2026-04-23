import 'dart:convert';

import '../../generated/json/base/json_field.dart';
import '../../generated/json/msg_clothing.g.dart';

class MsgClothing {
  final int? id;
  final String? togsName;
  final int? togsType;
  final String? img;
  final dynamic cdesc;
  final int? itemPrice;

  MsgClothing({
    this.id,
    this.togsName,
    this.togsType,
    this.img,
    this.cdesc,
    this.itemPrice,
  });

  factory MsgClothing.fromRawJson(String str) => MsgClothing.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MsgClothing.fromJson(Map<String, dynamic> json) => MsgClothing(
    id: json["id"],
    togsName: json["togs_name"],
    togsType: json["togs_type"],
    img: json["img"],
    cdesc: json["cdesc"],
    itemPrice: json["item_price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "togs_name": togsName,
    "togs_type": togsType,
    "img": img,
    "cdesc": cdesc,
    "item_price": itemPrice,
  };
}

@JsonSerializable()
class ChangeClothe {
  int? id;
  int? clothingType;
  String? modelId;

  ChangeClothe({this.id, this.clothingType, this.modelId});

  factory ChangeClothe.fromJson(Map<String, dynamic> json) => ChangeClothe(
    id: json["id"],
    clothingType: json["clothing_type"],
    modelId: json["model_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "clothing_type": clothingType,
    "model_id": modelId,
  };
}
