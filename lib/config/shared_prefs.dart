import 'package:shared_preferences/shared_preferences.dart';

const String keyTheme = 'theme';
const String _token = 'token';
const String _firstTime = 'first-time';
const String _notificationStatus = 'notification-status';

class SharedPrefs {
  static SharedPreferences? _sharedPrefs;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _sharedPrefs ??= await SharedPreferences.getInstance();
  }

  Future<void> setNotificationStatus(bool value) async {
    if (_sharedPrefs != null) {
      await _sharedPrefs?.setBool(_notificationStatus, value);
    }
  }

  bool get notificationStatus =>
      _sharedPrefs?.getBool(_notificationStatus) ?? false;

  bool get checkPrefsNull =>
      _sharedPrefs != null && _sharedPrefs!.containsKey(keyTheme);

  int get theme => _sharedPrefs?.getInt(keyTheme) ?? 0;

  String? get token => _sharedPrefs?.getString(_token);

  bool get isFirstTime => _sharedPrefs?.getBool(_firstTime) ?? false;

  Future<void> setToken(String value) async {
    if (_sharedPrefs != null) {
      await _sharedPrefs?.setString(_token, value);
    }
  }

  Future<bool> deleteEverything() async {
    print('This runs -7');
    if (_sharedPrefs != null) {
      print('This runs -6');
      final result = await _sharedPrefs?.clear();
      return result ?? false;
    }
    return false;
  }

  Future<void> setFirstTime() async {
    if (_sharedPrefs != null) {
      await _sharedPrefs?.setBool(_firstTime, true);
    }
  }

  //setTheme
  // We can access this as await SharedPrefs().setTheme(event.theme.index);
  Future<void> setTheme(int value) async {
    if (_sharedPrefs != null) {
      await _sharedPrefs?.setInt(keyTheme, value);
    }
  }
}
