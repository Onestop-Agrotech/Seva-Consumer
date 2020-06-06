import 'dart:convert';

List<Store> jsonToStoreModel(String str) => List<Store>.from(json.decode(str).map((x) => Store.fromJson(x)));

String storeTojsonModel(List<Store> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Store {
    Store({
        this.name,
        this.username,
        this.uniqueId,
        this.address,
        this.lat,
        this.long,
        this.vegetables, 
        this.fruits
    });

    String name;
    String username;
    String uniqueId;
    String address;
    String lat;
    String long;
    bool vegetables;
    bool fruits;

    factory Store.fromJson(Map<String, dynamic> json) => Store(
        name: json["name"],
        username: json["username"],
        uniqueId: json["uniqueId"],
        address: json["address"],
        lat: json["lat"],
        long: json["long"],
        vegetables: json["vegetables"],
        fruits: json["fruits"]
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "uniqueId": uniqueId,
        "address": address,
        "lat": lat,
        "long": long,
    };
}
