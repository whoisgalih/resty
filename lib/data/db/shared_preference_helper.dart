import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  final _prefs = SharedPreferences.getInstance();

  final String _isScheduled = 'isScheduled';

  Future<bool> setScheduledNews(bool value) async {
    final prefs = await _prefs;
    return prefs.setBool(_isScheduled, value);
  }

  Future<bool> get isScheduled async {
    final prefs = await _prefs;
    return prefs.getBool(_isScheduled) ?? false;
  }
}
