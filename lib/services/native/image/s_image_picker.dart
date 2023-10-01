import 'dart:io' show File;

import 'package:my_notes/core/app_module.dart';
import 'package:my_notes/services/native/image/packages/image_picker_package_impl.dart';

import 'image_picker.dart';
export './image_picker.dart';

class ImagePickerService extends ImagePicker {
  factory ImagePickerService.packageImagePicker() =>
      ImagePickerService._(ImagePickerPackageImpl());

  factory ImagePickerService.getInstance() => AppModule.imagePickerService;
  final ImagePicker _picker;

  ImagePickerService._(this._picker);

  @override
  Future<void> initialize() => _picker.initialize();

  @override
  Future<void> deInitialize() => _picker.deInitialize();

  @override
  bool get isInitialized => _picker.isInitialized;

  @override
  Future<File?> pickImage(
          {required ImageSource source,
          double? maxWidth,
          double? maxHeight,
          int? imageQuality,
          CameraDevice preferredCameraDevice = CameraDevice.rear,
          bool requestFullMetadata = true}) =>
      _picker.pickImage(
        source: source,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
        preferredCameraDevice: preferredCameraDevice,
        requestFullMetadata: requestFullMetadata,
      );
}
