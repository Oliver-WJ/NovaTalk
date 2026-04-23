import 'dart:convert';

class MsgToys {
  final int? id;
  final String? tipName;
  final int? tipType;
  final String? img;
  final String? gdesc;
  final int? itemPrice;

  MsgToys({this.id, this.tipName, this.tipType, this.img, this.gdesc, this.itemPrice});

  factory MsgToys.fromRawJson(String str) => MsgToys.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MsgToys.fromJson(Map<String, dynamic> json) => MsgToys(
    id: json["id"],
    tipName: json["gname"],
    tipType: json["gtype"],
    img: json["img"],
    gdesc: json["gdesc"],
    itemPrice: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "gname": tipName,
    "gtype": tipType,
    "img": img,
    "gdesc": gdesc,
    "price": itemPrice,
  };
}
