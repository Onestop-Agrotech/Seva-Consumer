import 'dart:convert';

List<StoreProduct> jsonToStoreProductModel(String str) =>
    List<StoreProduct>.from(
        json.decode(str).map((x) => StoreProduct.fromJson(x)));

String storeProductTojsonModel(List<StoreProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreProduct {
  String id;
  String name;
  String type;
  String uniqueId;
  String description;
  String pictureURL;
  double totalPrice;
  double totalQuantity;
  List<Details> details;
  int iV;

  StoreProduct(
      {this.id,
      this.name,
      this.type,
      this.uniqueId,
      this.description,
      this.pictureURL,
      this.details,
      this.totalPrice = 0,
      this.totalQuantity = 0,
      this.iV});

  factory StoreProduct.fromJson(Map<String, dynamic> json) => StoreProduct(
      id: json['_id'],
      name: json['name'],
      type: json['type'],
      uniqueId: json['uniqueId'],
      description: json['description'],
      pictureURL: json['pictureURL'],
      details:
          List<Details>.from(json["details"].map((x) => Details.fromJson(x))),
      iV: json['__v']);

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'type': type,
        'uniqueId': uniqueId,
        'description': description,
        'pictureURL': pictureURL,
        'details': List<dynamic>.from(details.map((x) => x.toJson())),
        '__v': iV
      };
}

class Details {
  Quantity quantity;
  String id;
  String hubid;
  int price;
  bool outOfStock;
  bool bestseller;

  Details(
      {this.quantity,
      this.id,
      this.hubid,
      this.price,
      this.outOfStock,
      this.bestseller});

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        quantity: Quantity.fromJson(json['quantity']),
        id: json['_id'],
        hubid: json['hubid'],
        price: json['price'],
        outOfStock: json['outOfStock'],
        bestseller: json['bestseller'],
      );

  Map<String, dynamic> toJson() => {
        'quantity': quantity.toJson(),
        '_id': id,
        'hubid': hubid,
        'price': price,
        'outOfStock': outOfStock,
        'bestseller': bestseller,
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
  String id;
  int value;
  String metric;
  int qty;

  AllowedQuantity({this.id, this.value, this.metric,this.qty = 0});

  factory AllowedQuantity.fromJson(Map<String, dynamic> json) =>
      AllowedQuantity(
          id: json['_id'],
          value: json['quantityValue'],
          metric: json['quantityMetric']);

  Map<String, dynamic> toJson() => {
        "quantityValue": value,
        "quantityMetric": metric,
      };
}
