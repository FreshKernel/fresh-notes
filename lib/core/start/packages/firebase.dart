import 'package:firebase_core/firebase_core.dart';
import 'package:my_notes/core/services/service.dart';

class FirebaseService extends AppService {
  FirebaseService._();
  static final _instance = FirebaseService._();
  factory FirebaseService.getInstance() => _instance;

  var _isFirebaseInitialized = false;

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp();
    _isFirebaseInitialized = true;
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
