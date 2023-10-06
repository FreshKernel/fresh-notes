import '../data/notes/cloud/s_cloud_notes.dart';
import '../data/notes/database/s_local_notes.dart';
import '../logic/auth/auth_service.dart';
import '../logic/native/image/s_image_picker.dart';
import '../logic/native/share/s_app_share.dart';

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
