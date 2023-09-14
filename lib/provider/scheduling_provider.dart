import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:resty/data/db/shared_preference_helper.dart';
import 'package:resty/utils/background_service.dart';
import 'package:resty/utils/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  final SharedPreferencesHelper _sharedPreferencesHelper;

  SchedulingProvider() : _sharedPreferencesHelper = SharedPreferencesHelper() {
    _getScheduledNews();
  }

  bool _isScheduled = false;

  bool get isScheduled => _isScheduled;

  Future<void> _getScheduledNews() async {
    _isScheduled = await _sharedPreferencesHelper.isScheduled;
    notifyListeners();
  }

  Future<bool> scheduledNotification(bool value) async {
    _isScheduled = value;
    await _sharedPreferencesHelper.setScheduledNews(value);
    if (_isScheduled) {
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        const Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
