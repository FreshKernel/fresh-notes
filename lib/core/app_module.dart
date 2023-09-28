import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/database/notes/s_local_notes.dart';

class AppModule {
  const AppModule._();
  static final LocalNotesService localNotesService =
      LocalNotesService.sqflite();
  static final AuthService authService = AuthService.firebase();
}
