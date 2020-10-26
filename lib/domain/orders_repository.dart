import 'dart:convert';
import 'dart:io';
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'package:mvp/domain/exceptions.dart';
import 'package:mvp/models/ordersModel.dart';
import 'package:http/http.dart' as http;

abstract class OrdersRepository {
  Future<List<OrderModel>> fetchOrders();
}

class OrdersRepositoryImpl implements OrdersRepository {
  Future _fetch() async {
    try {
      final p = await Preferences.getInstance();
      String id = await p.getData("id");
      String token = await p.getData("token");
      String url = APIService.ordersAPI + "$id";
      Map<String, String> requestHeaders = {'x-auth-token': token};
      var response = await http.get(url, headers: requestHeaders);
      var responseJson = await _returnResponse(response);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet Connection!');
    }
  }

  @override
  Future<List<OrderModel>> fetchOrders() async {
    return await _fetch();
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
      throw FetchDataException("No Internet");
    }
  }

  Future<List<OrderModel>> _returnResponse(http.Response response) async {
    switch (response.statusCode) {
      case 200:
        final List<OrderModel> sp =
            toOrdersFromJson(json.decode(response.body)["orders"]);
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
