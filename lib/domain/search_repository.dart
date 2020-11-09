import 'dart:io';
import 'dart:convert';
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/domain/exceptions.dart';
import 'package:mvp/models/storeProducts.dart';
import 'package:http/http.dart' as http;

abstract class SearchRepository {
  Future<List<StoreProduct>> fetch(String query);
}

class SearchRepositoryImpl extends SearchRepository {
  @override
  Future<List<StoreProduct>> fetch(String query) async {
    try {
      final p = await Preferences.getInstance();
      String token = await p.getData("token");
      String hub = await p.getData("hub");
      Map<String, String> requestHeaders = {'x-auth-token': token};
      String url = "http://localhost:8000/api/products/search/$query/$hub";
      var response = await http.get(url, headers: requestHeaders);
      var responseJson = await _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet Connection!');
    }
  }

  refreshToken() async {
    try {
      final p = await Preferences.getInstance();
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
    } on SocketException {
      throw FetchDataException('No Internet Connection!');
    }
  }

  Future<List<StoreProduct>> _returnResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
        final List<StoreProduct> sp = jsonToStoreProductModel(response.body);
        return sp;
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
