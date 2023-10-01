import 'dart:io' show File;

import '../../../core/services/s_app.dart';

import 'enums/camera_device.dart';
import 'enums/image_source.dart';

export 'enums/camera_device.dart';
export 'enums/image_source.dart';

abstract class ImagePicker extends AppService {
  Future<File?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  });
}
