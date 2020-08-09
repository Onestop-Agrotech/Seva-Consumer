import 'dart:convert';

List<StoreProduct> jsonToStoreProductModel(String str) =>
    List<StoreProduct>.from(
        json.decode(str).map((x) => StoreProduct.fromJson(x)));

String storeProductTojsonModel(List<StoreProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreProduct {
  StoreProduct(
      {this.quantity,
      this.id,
      this.name,
      this.type,
      this.uniqueId,
      this.description,
      this.price,
      this.pictureUrl,
      this.totalPrice = 0,
      this.totalQuantity = 0,
      this.outOfStock});

  String id;
  String name;
  String type;
  String uniqueId;
  String description;
  int price;
  String pictureUrl;
  double totalPrice;
  double totalQuantity;
  Quantity quantity;
  bool outOfStock;

  factory StoreProduct.fromJson(Map<String, dynamic> json) => StoreProduct(
        id: json["_id"],
        name: json["name"],
        type: json["type"],
        uniqueId: json["uniqueId"],
        description: json["description"],
        price: json["price"],
        pictureUrl: json["pictureURL"],
        outOfStock: json["outOfStock"],
        quantity: Quantity.fromJson(json["quantity"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "type": type,
        "uniqueId": uniqueId,
        "description": description,
        "price": price,
        "pictureURL": pictureUrl,
        "quantity": quantity.toJson(),
      };
}

class Quantity {
  Quantity({this.quantityValue, this.quantityMetric, this.allowedQuantities});

  int quantityValue;
  String quantityMetric;
  List<AllowedQuantity> allowedQuantities;

  factory Quantity.fromJson(Map<String, dynamic> json) => Quantity(
        quantityValue: json["quantityValue"],
        quantityMetric: json["quantityMetric"],
        allowedQuantities: List<AllowedQuantity>.from(
            json["allowedQuantities"].map((x) => AllowedQuantity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "quantityValue": quantityValue,
        "quantityMetric": quantityMetric,
      };
}

class AllowedQuantity {
  AllowedQuantity({this.value, this.metric, this.qty = 0});
  int value;
  String metric;
  int qty;

  factory AllowedQuantity.fromJson(Map<String, dynamic> json) =>
      AllowedQuantity(
        value: json["quantityValue"],
        metric: json["quantityMetric"],
      );

  Map<String, dynamic> toJson() => {
        "quantityValue": value,
        "quantityMetric": metric,
      };
}
