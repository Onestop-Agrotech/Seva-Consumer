import 'dart:convert';
import 'dart:io';

import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/classes/storeProducts_box.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/domain/exceptions.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:http/http.dart' as http;

abstract class ProductRepository {
  Future<List<StoreProduct>> fetchProducts(String type);
  Future<List<StoreProduct>> fetchBestSellers();
}

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<StoreProduct>> fetchProducts(type) async {
    final SPBox spBox = await SPBox.getSPBoxInstance();
    final List<StoreProduct> sp = spBox.getFromSPBox(type);
    if (sp.length == 0) {
      var responseJson;
      try {
        final p = await Preferences.getInstance();
        String token = await p.getData("token");
        String hub = await p.getData("hub");
        Map<String, String> requestHeaders = {'x-auth-token': token};
        String url = APIService.getCategorywiseProducts(hub, type);
        final response = await http.get(url, headers: requestHeaders);
        responseJson = await _returnResponse(response, "products");
        return responseJson;
      } on SocketException {
        throw FetchDataException('No Internet connection');
      }
    } else if (sp.length > 0) {
      return sp;
    }
    return null;
  }

  Future<List<StoreProduct>> fetchBestSellers() async {
    try {
      final p = await Preferences.getInstance();
      String token = await p.getData("token");
      String hub = await p.getData("hub");
      Map<String, String> requestHeaders = {'x-auth-token': token};
      String url = APIService.getBestSellers(hub);
      var response = await http.get(url, headers: requestHeaders);
      var responseJson = await _returnResponse(response, "bestsellers");
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet Connection!');
    }
  }

  refreshToken() async {
    try {
      final p = await Preferences.getInstance();
      // String token = await p.getData("token");
      String refreshToken = await p.getData("refreshToken");
      String url = APIService.getRefreshToken;
      var body = jsonEncode(<String, String>{
        'refreshToken': refreshToken,
      });
      Map<String, String> requestHeaders = {'x-auth-token': refreshToken};
      final response =
          await http.post(url, body: body, headers: requestHeaders);
      var jsonBdy = json.decode(response.body);
      await p.setToken(jsonBdy["token"]);
      await p.setRefreshToken(jsonBdy["refreshToken"]);

      // user=
    } on SocketException {
      throw FetchDataException('No Internet Connection!');
    }
  }

  Future<List<StoreProduct>> _returnResponse(
      http.Response response, String api) async {
    switch (response.statusCode) {
      case 200:
        if (api == "products") {
          print("if");
          final List<StoreProduct> sp =
              jsonToCateogrywiseProductModel(response.body);
          final SPBox spBox = await SPBox.getSPBoxInstance();
          spBox.addSPList(sp);
          return sp;
        } else {
          print("else");
          final List<StoreProduct> bestsellers = jsonToStoreProductModel(response.body);
          return bestsellers;
        }
        return null;
      case 401:
        throw UnauthorisedException(response.statusCode.toString());
      case 500:
        throw InternalServerError();
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
