// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{02-09-2020}

///
/// @fileoverview store product model : models all the products visible in the product
/// section with the database.
///

import 'dart:convert';

import 'package:hive/hive.dart';

part 'storeProducts.g.dart';

List<StoreProduct> jsonToStoreProductModel(String str) =>
    List<StoreProduct>.from(
        json.decode(str).map((x) => StoreProduct.fromJson(x)));

List<StoreProduct> jsonToCateogrywiseProductModel(String str) =>
    List<StoreProduct>.from(
        json.decode(str)['products'].map((x) => StoreProduct.fromJson(x)));

String storeProductTojsonModel(List<StoreProduct> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

// main store product model
@HiveType(typeId: 1)
class StoreProduct extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String type;
  @HiveField(3)
  String uniqueId;
  @HiveField(4)
  String description;
  @HiveField(5)
  String pictureURL;
  @HiveField(6)
  List<Details> details;
  int iV;
  @HiveField(7)
  double totalPrice;
  @HiveField(8)
  double totalQuantity;

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

// details of a particular item [array]
@HiveType(typeId: 2)
class Details extends HiveObject {
  @HiveField(0)
  Quantity quantity;
  @HiveField(1)
  String id;
  @HiveField(2)
  String hubid;
  @HiveField(3)
  int price;
  @HiveField(4)
  bool outOfStock;
  @HiveField(5)
  bool bestseller;
  @HiveField(6)
  String notes;

  Details(
      {this.quantity,
      this.id,
      this.hubid,
      this.price,
      this.outOfStock,
      this.bestseller,
      this.notes});

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        quantity: Quantity.fromJson(json['quantity']),
        id: json['_id'],
        hubid: json['hubid'],
        price: json['price'],
        outOfStock: json['outOfStock'],
        bestseller: json['bestseller'],
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        'quantity': quantity.toJson(),
        '_id': id,
        'hubid': hubid,
        'price': price,
        'outOfStock': outOfStock,
        'bestseller': bestseller,
        "notes": notes
      };
}

// quantity of the item
@HiveType(typeId: 3)
class Quantity extends HiveObject {
  Quantity({this.quantityValue, this.quantityMetric, this.allowedQuantities});

  @HiveField(0)
  int quantityValue;
  @HiveField(1)
  String quantityMetric;
  @HiveField(2)
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

@HiveType(typeId: 4)
class AllowedQuantity extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  int value;
  @HiveField(2)
  String metric;
  @HiveField(3)
  int qty;

  AllowedQuantity({this.id, this.value, this.metric, this.qty = 0});

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
