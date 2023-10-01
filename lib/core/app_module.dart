import '../services/auth/auth_service.dart';
import '../services/cloud/note/s_cloud_notes.dart';
import '../services/database/notes/s_local_notes.dart';
import '../services/native/image/s_image_picker.dart';
import '../services/native/share/s_app_share.dart';

class AppModule {
  const AppModule._();
  // Notes
  static final LocalNotesService localNotesService =
      LocalNotesService.sqflite();
  static final CloudNotesService cloudNotesService =
      CloudNotesService.firebaseFirestore();

  // Other Service
  static final AuthService authService = AuthService.firebase();
  static final ImagePickerService imagePickerService =
      ImagePickerService.packageImagePicker();
  static final AppShareService appShareService = AppShareService.sharePlus();
}
