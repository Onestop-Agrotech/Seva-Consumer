import 'package:hive/hive.dart';

class Preferences {
  static const _preferencesBox = '_preferencesBox';
  final Box<dynamic> _box;

  Preferences._(this._box);

  // This doesn't have to be a singleton.
  // We just want to make sure that the box is open, before we start getting/setting objects on it
  static Future<Preferences> getInstance() async {
    final box = await Hive.openBox<dynamic>(_preferencesBox);
    return Preferences._(box);
  }

// storing the user creds after login
// and registration
  Future<void> setToken(String token) => _setValue("token", token);
  Future<void> setRefreshToken(String refreshToken) =>
      _setValue("refreshToken", refreshToken);
  Future<void> setUsername(String username) => _setValue("username", username);
  Future<void> setFarStatus(String far) => _setValue("far", far);
  Future<void> setEmail(String email) => _setValue("email", email);
  Future<void> setId(String id) => _setValue("id", id);
  Future<void> sethub(String hub) => _setValue("hub", hub);
  Future<void> setMobile(String mobile) => _setValue("mobile", mobile);

// common function to set the value
// as per key
  Future<void> _setValue<T>(dynamic key, T value) => _box.put(key, value);

// Common function to get data
// as per key
  getData(String key) => _getValue(key);
  T _getValue<T>(dynamic key, {T defaultValue}) =>
      _box.get(key, defaultValue: defaultValue) as T;
}
