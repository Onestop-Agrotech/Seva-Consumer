// Copyright 2020 SEVA AUTHORS. All Rights Reserved.
//
// (change the version and the date whenver anyone worked upon this file)
// Version-0.4.8
// Date-{03-09-2020}

///
/// @fileoverview Razorpay : Redirect to razorpay for payment.
///

import 'package:http/http.dart' as http;
import 'package:mvp/classes/prefrenses.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'dart:convert';

class RazorPaySeva {
  // get rzp key
  Future<String> getRzpAPIKEY() async {
    final p = await Preferences.getInstance();
    String token = await p.getData("token");
    Map<String, String> headers = {"x-auth-token": token};
    String url = APIService.getRzpKeyAPI;
    var response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      String apiKey = json.decode(response.body)["rzp"];
      return apiKey;
    } else {
      throw Exception('something is wrong');
    }
  }
}
