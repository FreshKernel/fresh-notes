import 'package:firebase_core/firebase_core.dart';
import '../../services/s_app.dart';

class FirebaseService extends AppService {
  factory FirebaseService.getInstance() => _instance;
  FirebaseService._();
  static final _instance = FirebaseService._();

  var _isFirebaseInitialized = false;

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp();
    _isFirebaseInitialized = true;
  }

  @override
  Future<void> deInitialize() async {
    await Firebase.apps.first.delete();
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
