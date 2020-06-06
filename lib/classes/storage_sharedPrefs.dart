import 'package:shared_preferences/shared_preferences.dart';

class StorageSharedPrefs {

  // set token to storage
  void setToken(String token) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // get token from storage
  Future<String> getToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.get('token');
    return token;
  }
}