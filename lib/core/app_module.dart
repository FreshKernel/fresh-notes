import 'package:my_notes/services/auth/auth_service.dart';
import 'package:my_notes/services/cloud/note/s_cloud_notes.dart';
import 'package:my_notes/services/database/notes/s_local_notes.dart';
import 'package:my_notes/services/native/image/s_image_picker.dart';

class AppModule {
  const AppModule._();
  // Notes
  static final LocalNotesService localNotesService =
      LocalNotesService.sqflite();
  static final CloudNotesService cloudNotesService =
      CloudNotesService.firebaseFirestore();

  static final AuthService authService = AuthService.firebase();
  static final ImagePickerService imagePickerService =
      ImagePickerService.packageImagePicker();
}
