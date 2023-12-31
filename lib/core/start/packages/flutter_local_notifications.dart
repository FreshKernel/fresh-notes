import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../errors/exceptions.dart';
import '../../service/s_app.dart';

class FlutterLocalNotificationsService extends AppService {
  factory FlutterLocalNotificationsService.getInstance() => instance;
  FlutterLocalNotificationsService._();

  static final FlutterLocalNotificationsService instance =
      FlutterLocalNotificationsService._();

  FlutterLocalNotificationsPlugin? _localNotificationsPlugin;
  FlutterLocalNotificationsPlugin get localNotificationsPlugin =>
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
  }

  Future<void> requestPermission() async {
    await _localNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _localNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
    await _localNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions();
    await _localNotificationsPlugin
        ?.resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions();
  }

  @override
  bool get isInitialized => _localNotificationsPlugin != null;
}
