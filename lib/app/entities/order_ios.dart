import "dart:convert";

class OrderIos {
  final String? amount;
  final String? appleResponse;
  final int? createTime;
  final int? deservedGems;
  final String? deviceId;
  final int? id;
  final String? orderType;
  final String? originalTransactionId;
  final String? purchaseDate;
  final String? receipt;
  final String? rechargeStatus;
  final String? skuId;
  final String? transactionId;
  final int? updateTime;
  final String? userId;
  final String? orderNo;

  OrderIos({
    this.amount,
    this.appleResponse,
    this.createTime,
    this.deservedGems,
    this.deviceId,
    this.id,
    this.orderType,
    this.originalTransactionId,
    this.purchaseDate,
    this.receipt,
    this.rechargeStatus,
    this.skuId,
    this.transactionId,
    this.updateTime,
    this.userId,
    this.orderNo,
  });

  factory OrderIos.fromRawJson(String str) =>
      OrderIos.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory OrderIos.fromJson(Map<String, dynamic> json) => OrderIos(
    amount: json["amount"],
    appleResponse: json["apple_response"],
    createTime: json["create_time"],
    deservedGems: json["deserved_gems"],
    deviceId: json["device_id"],
    id: json["id"],
    orderType: json["order_type"],
    originalTransactionId: json["original_transaction_id"],
    purchaseDate: json["purchase_date"],
    receipt: json["receipt"],
    rechargeStatus: json["recharge_status"],
    skuId: json["sku_id"],
    transactionId: json["transaction_id"],
    updateTime: json["update_time"],
    userId: json["user_id"],
    orderNo: json["order_no"],
  );

  Map<String, dynamic> toJson() => {
    "amount": amount,
    "apple_response": appleResponse,
    "create_time": createTime,
    "deserved_gems": deservedGems,
    "device_id": deviceId,
    "id": id,
    "order_type": orderType,
    "original_transaction_id": originalTransactionId,
    "purchase_date": purchaseDate,
    "receipt": receipt,
    "recharge_status": rechargeStatus,
    "sku_id": skuId,
    "transaction_id": transactionId,
    "update_time": updateTime,
    "user_id": userId,
    "order_no": orderNo,
  };
}
