import 'dart:convert';
import 'package:in_app_purchase/in_app_purchase.dart';

class Sku {
  // final String? id;
  final String? sku;
  final String? name;
  // final double? price;
  final int? number;
  final int? orderNum; // 排序

  /// 默认选中
  final bool? defaultSku;
  final bool? lifetime;

  ///  GEMS(0, "钻石"),   VIP(1, "VIP"), SVIP(2, "SVIP"),   NOT_VIP(3, "非VIP");
  // final int? skuLevel;
  // GEMS(0, "钻石"), WEEK(1, "周卡"),  MONTH(2, "月卡"), YEAR(3, "年卡"),  LIFETIME(4, "永久订阅"),
  final int? skuType;
  final int? createImg;
  final int? createVideo;

  /// 是否上架
  final bool? shelf;

  ///  @VL(value = "1", label = "Best Value"),
  /// @VL(value = "2", label = "Most Popular"),
  /// @VL(value = "3", label = "\uD83D\uDD25Save 75%")
  final int? tag;

  ProductDetails? productDetails;

  Sku({
    // this.id,
    this.sku,
    this.name,
    // this.price,
    this.number,
    this.defaultSku,
    this.lifetime,
    // this.skuLevel,
    this.skuType,
    this.createImg,
    this.createVideo,
    this.shelf,
    this.tag,
    this.orderNum,
    this.productDetails,
  });

  factory Sku.fromRawJson(String str) => Sku.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Sku.fromJson(Map<String, dynamic> json) => Sku(
        // id: json["id"],
        sku: json["sku"],
        name: json["name"],
        // price: json["price"]?.toDouble(),
        number: json["number"],
        defaultSku: json["default_sku"],
        lifetime: json["lifetime"],
        // skuLevel: json["sku_level"],
        skuType: json["sku_type"],
        createImg: json["create_img"],
        createVideo: json["create_video"],
        shelf: json["shelf"],
        tag: json["tag"],
        orderNum: json["order_num"],
      );

  Map<String, dynamic> toJson() => {
        // "id": id,
        "sku": sku,
        "name": name,
        // "price": price,
        "number": number,
        "default_sku": defaultSku,
        "lifetime": lifetime,
        // "sku_level": skuLevel,
        "sku_type": skuType,
        "create_img": createImg,
        "create_video": createVideo,
        "shelf": shelf,
        "tag": tag,
        "order_num": orderNum,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Sku && runtimeType == other.runtimeType && sku == other.sku;

  @override
  int get hashCode => sku.hashCode;
}
