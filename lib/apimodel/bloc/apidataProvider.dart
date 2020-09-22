import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mvp/models/storeProducts.dart';

class ApiDataProvider {

  String baseUrl = "https://api.theonestop.co.in/api";

  Future<List<StoreProduct>> getBestSellers(String hubid) async {
    final response = await http.get(baseUrl + "/products/all/bestsellers/hub/$hubid");

    return parseResponse(response);
  }

  List<StoreProduct> parseResponse(http.Response response) {

    if (response.statusCode == 200) {
     return jsonToStoreProductModel(response.body);

    } else {
      throw Exception('failed to load players');
    }
  }
}