import 'dart:convert';

OrderModel toOrderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String fromOrderModelToJson(OrderModel data) => json.encode(data.toJson());

List<OrderModel> toOrdersFromJson(b) =>
    List<OrderModel>.from(b.map((x) => OrderModel.fromJson(x)));

class OrderModel {
  OrderModel({
    this.time,
    this.id,
    this.orderNumber,
    this.customerId,
    this.customerPhone,
    this.customerAddress,
    this.orderOriginLat,
    this.orderOriginLong,
    this.items,
    this.orderType,
    this.finalItemsPrice,
    this.deliveryPrice,
    this.customerFinalPrice,
    this.paymentType,
    this.paymentTransactionId,
    this.orderStatus,
  });

  Time time;
  String id;
  String orderNumber;
  String customerId;
  String customerPhone;
  String customerAddress;
  String orderOriginLat;
  String orderOriginLong;
  List<Item> items;
  String orderType;
  String finalItemsPrice;
  String deliveryPrice;
  String customerFinalPrice;
  String paymentType;
  String paymentTransactionId;
  String orderStatus;

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        time: Time.fromJson(json["time"]),
        id: json["_id"],
        orderNumber: json["orderNumber"],
        customerId: json["customerId"],
        customerPhone: json["customerPhone"],
        customerAddress: json["customerAddress"],
        orderOriginLat: json["orderOriginLat"],
        orderOriginLong: json["orderOriginLong"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        orderType: json["orderType"],
        finalItemsPrice: json["finalItemsPrice"],
        deliveryPrice: json["deliveryPrice"],
        customerFinalPrice: json["customerFinalPrice"],
        paymentType: json["paymentType"],
        paymentTransactionId: json["paymentTransactionId"],
        orderStatus: json["orderStatus"],
      );

  Map<String, dynamic> toJson() => {
        "time": time.toJson(),
        "_id": id,
        "orderNumber": orderNumber,
        "customerId": customerId,
        "customerPhone": customerPhone,
        "customerAddress": customerAddress,
        "orderOriginLat": orderOriginLat,
        "orderOriginLong": orderOriginLong,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "orderType": orderType,
        "finalItemsPrice": finalItemsPrice,
        "deliveryPrice": deliveryPrice,
        "customerFinalPrice": customerFinalPrice,
        "paymentType": paymentType,
        "paymentTransactionId": paymentTransactionId,
        "orderStatus": orderStatus,
      };
}

class Item {
  Item({
    this.id,
    this.itemId,
    this.name,
    this.totalPrice,
    this.totalQuantity,
  });

  String id;
  String itemId;
  String name;
  String totalPrice;
  String totalQuantity;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"],
        itemId: json["item_id"],
        name: json["name"],
        totalPrice: json["total_price"],
        totalQuantity: json["total_quantity"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "item_id": itemId,
        "name": name,
        "total_price": totalPrice,
        "total_quantity": totalQuantity,
      };
}

class Time {
  Time({
    this.orderTimestamp,
  });

  DateTime orderTimestamp;

  factory Time.fromJson(Map<String, dynamic> json) => Time(
        orderTimestamp: DateTime.parse(json["orderTimestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "orderTimestamp": orderTimestamp.toIso8601String(),
      };
}
