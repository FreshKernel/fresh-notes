import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/database/notes/s_local_notes.dart';
import 'package:my_notes/services/native/image/s_image_picker.dart';

class AppModule {
  const AppModule._();
  static final LocalNotesService localNotesService =
      LocalNotesService.sqflite();
  static final AuthService authService = AuthService.firebase();
  static final ImagePickerService imagePickerService =
      ImagePickerService.packageImagePicker();
}
