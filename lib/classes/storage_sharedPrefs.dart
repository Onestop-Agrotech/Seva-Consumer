import 'package:shared_preferences/shared_preferences.dart';

class StorageSharedPrefs {
  // set token to storage
  Future<void> setToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // set username to storage
  Future<void> setUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  // set id to storage
  Future<void> setId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
  }

  // get token from storage
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await prefs.get('token');
    return token;
  }

  // get username from storage
  Future<String> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = await prefs.get('username');
    return username;
  }

  // get Id from Storage
  Future<String> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = await prefs.get('id');
    return id;
  }
}
