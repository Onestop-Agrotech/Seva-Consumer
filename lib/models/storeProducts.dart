import 'dart:convert';

List<StoreProduct> jsonToStoreProductModel(String str) => List<StoreProduct>.from(json.decode(str).map((x) => StoreProduct.fromJson(x)));

String storeProductTojsonModel(List<StoreProduct> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StoreProduct {
    StoreProduct({
        this.id,
        this.name,
        this.type,
        this.uniqueId,
        this.description,
        this.pricePerQuantity,
        this.pictureUrl,
    });

    String id;
    String name;
    String type;
    String uniqueId;
    String description;
    String pricePerQuantity;
    String pictureUrl;

    factory StoreProduct.fromJson(Map<String, dynamic> json) => StoreProduct(
        id: json["_id"],
        name: json["name"],
        type: json["type"],
        uniqueId: json["uniqueId"],
        description: json["description"],
        pricePerQuantity: json["pricePerQuantity"],
        pictureUrl: json["pictureURL"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "type": type,
        "uniqueId": uniqueId,
        "description": description,
        "pricePerQuantity": pricePerQuantity,
        "pictureURL": pictureUrl,
    };
}
