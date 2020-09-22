import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/models/storeProducts.dart';

class ApiDataProvider {

  String baseUrl = "https://api.theonestop.co.in/api";

  Future<List<StoreProduct>> getBestSellers() async {
     StorageSharedPrefs p = new StorageSharedPrefs();
    String token = await p.getToken();
    String hub = await p.gethub();

    Map<String, String> requestHeaders = {'x-auth-token': token};
    final response = await http.get(baseUrl + "/products/all/bestsellers/hub/$hub",headers: requestHeaders);

    return parseResponse(response);
  }

  List<StoreProduct> parseResponse(http.Response response) {

    if (response.statusCode == 200) {
      print("response,$response");
     return jsonToStoreProductModel(response.body);

    } else {
      throw Exception('failed to load players');
    }
  }
}