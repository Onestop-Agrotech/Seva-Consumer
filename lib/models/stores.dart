import 'dart:convert';

List<Store> jsonToStoreModel(String str) =>
    List<Store>.from(json.decode(str).map((x) => Store.fromJson(x)));

String storeTojsonModel(List<Store> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Store {
  Store(
      {this.name,
      this.username,
      this.uniqueId,
      this.address,
      this.lat,
      this.long,
      this.pictureURL,
      this.vegetables,
      this.fruits,
      this.distance,
      this.online,
      this.dp});

  String name;
  String username;
  String uniqueId;
  String address;
  String lat;
  String long;
  String pictureURL;
  bool vegetables;
  bool fruits;
  bool online;
  String distance;
  double dp;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
      name: json["storeName"],
      username: json["storeUsername"],
      uniqueId: json["storeUniqueId"],
      address: json["address"],
      lat: json["lat"],
      long: json["long"],
      vegetables: json["vegetables"],
      pictureURL: json["pictureURL"],
      fruits: json["fruits"],
      distance: json["distance"],
      online: json["online"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "username": username,
        "uniqueId": uniqueId,
        "address": address,
        "lat": lat,
        "long": long,
      };

  List<Store> checkAndArrange(List<Store> stores) {
    if (stores.length > 0) {
      for (int i = 0; i < stores.length; ++i) {
        if (stores[i].distance.split(' ')[1] == 'm')
          stores[i].dp =
              (double.parse(stores[i].distance.split(' ')[0])) / 1000;
        else
          stores[i].dp = double.parse(stores[i].distance.split(' ')[0]);
      }
      stores.sort((a, b) => a.dp.compareTo(b.dp));
      // make an extra list here:
      var y = [];
      // pick off the obs which are online:false
      for (int i = 0; i < stores.length; ++i) {
        if (stores[i].online == false) y.add(stores[i]);
      }
      // remove the obs which are online:false
      stores.removeWhere((e) => e.online == false);

      // add all y obs back to stores
      for (int i = 0; i < y.length; ++i) {
        stores.add(y[i]);
      }
    }
    return stores;
  }
}
