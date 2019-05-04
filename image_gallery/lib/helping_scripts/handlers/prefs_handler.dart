import 'package:shared_preferences/shared_preferences.dart';

class PrefsHandler {
  static SharedPreferences _instance;

  PrefsHandler() {
    _initPrefs();
  }

  Future<bool> _initPrefs() async {
    if (_instance == null) {
      _instance = await SharedPreferences.getInstance();
    }
    return true;
  }

  void setString(String key, String value) {
    _instance.setString(key, value);
  }

  void setBool(String key, bool value) {
    _instance.setBool(key, value);
  }

  String getString(String key) {
    return _instance.getString(key);
  }

  SharedPreferences getInstance() {
    return _instance;
  }

  bool getBool(String key) {
    return _instance.getBool(key);
  }
}