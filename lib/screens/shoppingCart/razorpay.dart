import 'package:http/http.dart' as http;
import 'package:mvp/classes/storage_sharedPrefs.dart';
import 'package:mvp/constants/apiCalls.dart';
import 'dart:convert';

class RazorPaySeva {
  // get rzp key
  Future<String> getRzpAPIKEY() async {
    StorageSharedPrefs p = new StorageSharedPrefs();
    String token = await p.getToken();
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
