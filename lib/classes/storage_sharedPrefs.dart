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

  // set address status to storage
  Future<void> setFarStatus(String far) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('far', far);
  }

  // set user email to storage
  Future<void> setEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
  }

  // set id to storage
  Future<void> setId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
  }

  // set hub to storage
  Future<void> sethub(String hub) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('hub', hub);
  }

  // get Far status from storage
  Future<String> getFarStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String far = await prefs.get('far');
    return far;
  }

  // get Far status from storage
  Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.get('email');
    return email;
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

  // get hub from storage
  Future<String> gethub() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hub = await prefs.get('hub');
    return hub;
  }
}
