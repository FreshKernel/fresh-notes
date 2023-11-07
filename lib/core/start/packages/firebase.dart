import 'package:firebase_core/firebase_core.dart';
import '../../../firebase_options.dart';
import '../../services/exceptions.dart';
import '../../services/s_app.dart';

class FirebaseService extends AppService {
  factory FirebaseService.getInstance() => _instance;
  FirebaseService._();
  static final _instance = FirebaseService._();

  var _isFirebaseInitialized = false;

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // if (kDebugMode) {
    //   await FirebaseAppCheck.instance.activate(
    //     androidProvider: AndroidProvider.debug,
    //     appleProvider: AppleProvider.debug,
    //   );
    // } else {
    //   await FirebaseAppCheck.instance.activate();
    // }
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    // PlatformDispatcher.instance.onError = (error, stack) {
    //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    //   return true;
    // };
    // if (kDebugMode) {
    //   const host = 'localhost';
    //   // if (PlatformChecker.isAndroid()) {
    //   //   host = '10.0.0.2';
    //   // }
    //   try {
    //     FirebaseFirestore.instance.useFirestoreEmulator(host, 8082);
    //     await FirebaseAuth.instance.useAuthEmulator(host, 9092);
    //     await FirebaseStorage.instance.useStorageEmulator(host, 9190);
    //     AppLogger.log('Connected to the firebase emulator!');
    //   } catch (e) {
    //     AppLogger.error(
    //       'Error while connect to firebase emulator locally using the host $host',
    //     );
    //   }
    // }
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
