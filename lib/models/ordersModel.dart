import 'dart:convert';
import 'package:mvp/models/storeProducts.dart';

OrderModel toOrderModelFromJson(String str) => OrderModel.fromJson(json.decode(str));
String fromOrderModelToJson(OrderModel data) => json.encode(data.toJson());

List<OrderModel> toOrdersFromJson(b) =>  List<OrderModel>.from(b.map((x) => OrderModel.fromJson(x)));

class OrderModel {
    OrderModel({
        this.id,
        this.customerUsername,
        this.customerId,
        this.storeUserName,
        this.storeId,
        this.items,
        this.orderType,
        this.finalItemsPrice,
        this.deliveryPrice,
        this.customerFinalPrice,
        this.paymentType,
        this.paymentTransactionId,
        this.orderStatus,
        this.timestamp,
        this.v,
    });

    String id;
    String customerUsername;
    String customerId;
    String storeUserName;
    String storeId;
    List<Item> items;
    String orderType;
    String finalItemsPrice;
    String deliveryPrice;
    String customerFinalPrice;
    String paymentType;
    String paymentTransactionId;
    String orderStatus;
    DateTime timestamp;
    int v;

    factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json["_id"],
        customerUsername: json["customerUsername"],
        customerId: json["customerId"],
        storeUserName: json["storeUserName"],
        storeId: json["storeId"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        orderType: json["orderType"],
        finalItemsPrice: json["finalItemsPrice"],
        deliveryPrice: json["deliveryPrice"],
        customerFinalPrice: json["customerFinalPrice"],
        paymentType: json["paymentType"],
        paymentTransactionId: json["paymentTransactionId"],
        orderStatus: json["orderStatus"],
        timestamp: DateTime.parse(json["timestamp"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        // "_id": id,
        "customerUsername": customerUsername,
        "customerId": customerId,
        "storeUserName": storeUserName,
        "storeId": storeId,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
        "orderType": orderType,
        "finalItemsPrice": finalItemsPrice,
        "deliveryPrice": deliveryPrice,
        "customerFinalPrice": customerFinalPrice,
        "paymentType": paymentType,
        "paymentTransactionId": paymentTransactionId,
        // "orderStatus": orderStatus,
        // "timestamp": timestamp.toIso8601String(),
        // "__v": v,
    };
}

class Item {
    Item({
        this.id,
        this.itemId,
        this.name,
        this.totalPrice,
        this.totalQuantity,
        this.itemStoreId,
        this.quantity,
    });

    String id;
    String itemId;
    String name;
    String totalPrice;
    String totalQuantity;
    String itemStoreId;
    Quantity quantity;

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"],
        itemId: json["item_id"],
        name: json["name"],
        totalPrice: json["total_price"],
        totalQuantity: json["total_quantity"],
        itemStoreId: json["item_store_id"],
        quantity: Quantity.fromJson(json["quantity"]),
    );

    Map<String, dynamic> toJson() => {
        // "_id": id,
        "item_id": itemId,
        "name": name,
        "total_price": totalPrice,
        "total_quantity": totalQuantity,
        "item_store_id": itemStoreId,
        "quantity": quantity.toJson(),
    };
}