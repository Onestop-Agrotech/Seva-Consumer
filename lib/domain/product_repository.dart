import 'dart:convert';
import 'dart:io';

import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/domain/exceptions.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:http/http.dart' as http;

abstract class ProductRepository {
  Future<List<StoreProduct>> fetchVegetables();
  Future<List<StoreProduct>> fetchFruits();
  Future<List<StoreProduct>> fetchDailyEssentials();
}

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<StoreProduct>> fetchVegetables() async {
    var responseJson;
    try {
      StorageSharedPrefs p = new StorageSharedPrefs();
      String token = await p.getToken();
      String hub = await p.gethub();
      Map<String, String> requestHeaders = {'x-auth-token': token};
      String url = APIService.getCategorywiseProducts(hub, "vegetable");
      final response = await http.get(url, headers: requestHeaders);
      responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<StoreProduct>> fetchFruits() async {
    var responseJson;
    try {
      StorageSharedPrefs p = new StorageSharedPrefs();
      String token = await p.getToken();
      String hub = await p.gethub();
      Map<String, String> requestHeaders = {'x-auth-token': token};
      String url = APIService.getCategorywiseProducts(hub, "fruit");
      final response = await http.get(url, headers: requestHeaders);
      responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<List<StoreProduct>> fetchDailyEssentials() async {
    var responseJson;
    try {
      StorageSharedPrefs p = new StorageSharedPrefs();
      String token = await p.getToken();
      String hub = await p.gethub();
      Map<String, String> requestHeaders = {'x-auth-token': token};
      String url = APIService.getCategorywiseProducts(hub, "dailyEssential");
      final response = await http.get(url, headers: requestHeaders);
      responseJson = _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  refreshToken() async {
    try {
      StorageSharedPrefs p = new StorageSharedPrefs();
      String token = await p.getToken();
      String refreshToken = await p.getRefreshToken();
      String url = APIService.getRefreshToken;
      var body = jsonEncode(<String, String>{
        'refreshToken': refreshToken,
      });
      Map<String, String> requestHeaders = {'x-auth-token': token};
      final response =
          await http.post(url, body: body, headers: requestHeaders);
      var jsonBdy = json.decode(response.body);
      await p.setToken(jsonBdy["token"]);
      await p.setRefreshToken(jsonBdy["refreshToken"]);

      // user=
    } on SocketException {
      throw FetchDataException("No Internet");
    }
  }

  List<StoreProduct> _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonToCateogrywiseProductModel(response.body);
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
