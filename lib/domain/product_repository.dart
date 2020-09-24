import 'dart:io';

import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/domain/exceptions.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:http/http.dart' as http;

abstract class ProductRepository {
  Future<List<StoreProduct>> fetchVegetables();
}

class ProductRepositoryImpl implements ProductRepository {
  @override
  Future<List<StoreProduct>> fetchVegetables() async {
    var responseJson;
    try {
      StorageSharedPrefs p = new StorageSharedPrefs();
      String token = await p.getToken();
      String hub = await p.gethub();
      print(token);
      Map<String, String> requestHeaders = {'x-auth-token': ""};
      String url = APIService.getCategorywiseProducts(hub, "vegetable");
      final response = await http.get(url, headers: requestHeaders);
      responseJson = _returnResponse(response);
      print("wokring$responseJson");
     return responseJson;
    }
    
     on SocketException {
      throw FetchDataException('No Internet connection');
    }
   

  }

  List<StoreProduct> _returnResponse(http.Response response) {
    print(response.statusCode);
    switch (response.statusCode) {
      case 200:
        return jsonToCateogrywiseProductModel(response.body);
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
          print(UnauthorisedException(response.body.toString()).x);
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
