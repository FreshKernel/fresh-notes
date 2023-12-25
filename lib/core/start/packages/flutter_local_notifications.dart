import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../errors/exceptions.dart';
import '../../services/s_app.dart';

class FlutterLocalNotificationsService extends AppService {
  static FlutterLocalNotificationsPlugin? _localNotificationsPlugin;
  static FlutterLocalNotificationsPlugin get localNotificationsPlugin =>
      _localNotificationsPlugin ??
      (throw const AppException('The service has not started yet.'));
  @override
  Future<void> deInitialize() async {
    _localNotificationsPlugin = null;
  }

  @override
  Future<void> initialize() async {
    _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const darwin = DarwinInitializationSettings();
    await _localNotificationsPlugin?.initialize(
      const InitializationSettings(
        linux:
            LinuxInitializationSettings(defaultActionName: 'Open notification'),
        iOS: darwin,
        macOS: darwin,
        android: AndroidInitializationSettings('app_icon'),
      ),
    );
    // _localNotificationsPlugin?.resolvePlatformSpecificImplementation<
    //     AndroidFlutterLocalNotificationsPlugin>()
    //   ?..requestNotificationsPermission()
    //   ..requestExactAlarmsPermission();
    // _localNotificationsPlugin
    //     ?.resolvePlatformSpecificImplementation<
    //         IOSFlutterLocalNotificationsPlugin>()
    //     ?.requestPermissions();
  }

  @override
  bool get isInitialized => _localNotificationsPlugin != null;
}
