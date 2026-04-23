import "dart:convert";

class OrderAnd {
  final int? id;
  final String? orderNo;
  final String? deviceId;
  final String? userId;
  final String? skuId;
  final String? platform;
  final String? orderType;
  final bool? renew;

  OrderAnd({
    this.id,
    this.orderNo,
    this.deviceId,
    this.userId,
    this.skuId,
    this.platform,
    this.orderType,
    this.renew,
  });

  factory OrderAnd.fromRawJson(String str) => OrderAnd.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderAnd.fromJson(Map<String, dynamic> json) => OrderAnd(
        id: json["id"],
        orderNo: json["order_no"],
        deviceId: json["device_id"],
        userId: json["user_id"],
        skuId: json["sku_id"],
        platform: json["platform"],
        orderType: json["order_type"],
        renew: json["renew"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_no": orderNo,
        "device_id": deviceId,
        "user_id": userId,
        "sku_id": skuId,
        "platform": platform,
        "order_type": orderType,
        "renew": renew,
      };
}
