import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:my_notes/core/services/s_app.dart';
import 'package:my_notes/core/start/packages/firebase.dart';
import 'package:path_provider/path_provider.dart';

import '../../services/auth/auth_service.dart';
import '../../services/native/image/s_image_picker.dart';
import '../log/logger.dart';

class AppStartup extends AppService {
  AppStartup._();

  static final _instance = AppStartup._();
  factory AppStartup.getInstance() => _instance;

  final _services = <AppService>[
    FirebaseService.getInstance(),
    AuthService.getInstance(),
    ImagePickerService.getInstance()
  ];

  @override
  Future<void> initialize() async {
    for (final service in _services) {
      await service.initialize();
    }
    if (kDebugMode) {
      final dir = await getApplicationDocumentsDirectory();
      dir.list().listen((event) {
        AppLogger.log(event.toString());
      });
    }
  }

  @override
  Future<void> deInitialize() async {
    for (final service in _services) {
      await service.initialize();
    }
  }

  @override
  bool get isInitialized {
    final anyServiceIsNotInitalized =
        _services.any((service) => !service.isInitialized);
    return !anyServiceIsNotInitalized;
  }
}
