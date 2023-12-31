import 'package:cross_file/cross_file.dart' show XFile;

import '../../../core/service/s_app.dart';

import 'enums/camera_device.dart';
import 'enums/image_source.dart';

export 'enums/camera_device.dart';
export 'enums/image_source.dart';

abstract class ImagePicker extends AppService {
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  });
}
