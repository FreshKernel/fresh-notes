import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart'
    show FlutterError, PlatformDispatcher, kDebugMode;
import '../../services/exceptions.dart';
import '../../services/s_app.dart';

class FirebaseService extends AppService {
  factory FirebaseService.getInstance() => _instance;
  FirebaseService._();
  static final _instance = FirebaseService._();

  var _isFirebaseInitialized = false;

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp();
    if (kDebugMode) {
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.debug,
      );
    } else {
      await FirebaseAppCheck.instance.activate();
    }
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
    _isFirebaseInitialized = true;
  }

  @override
  Future<void> deInitialize() async {
    final apps = Firebase.apps;
    if (apps.isEmpty) {
      throw const ServiceNotInitializedException(
        'To deInitialize firebase, it must be initialize first.',
      );
    }
    await apps.first.delete();
  }

  @override
  bool get isInitialized => _isFirebaseInitialized;
}

// Future<FirebaseOptions> _getFirebaseOptions() async {
//   return const FirebaseOptions(
//     apiKey: '',
//     authDomain: '',
//     projectId: '',
//     storageBucket: '',
//     messagingSenderId: '',
//     appId: '',
//   );
// }
