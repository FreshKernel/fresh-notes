import 'package:cross_file/cross_file.dart';
import 'package:image_picker/image_picker.dart' as image_picker_package;
import 'package:image_picker_android/image_picker_android.dart';

import 'package:image_picker_platform_interface/image_picker_platform_interface.dart'
    as image_picker_package_platform_interface;

import '../image_picker.dart';

class ImagePickerPackageImpl extends ImagePicker {
  image_picker_package.ImagePicker? _imagePicker;

  @override
  Future<void> initialize() async {
    final imagePickerImplementation =
        image_picker_package_platform_interface.ImagePickerPlatform.instance;
    if (imagePickerImplementation is ImagePickerAndroid) {
      imagePickerImplementation.useAndroidPhotoPicker = true;
    }
    _imagePicker ??= image_picker_package.ImagePicker();
  }

  @override
  Future<void> deInitialize() async {
    _imagePicker = null;
  }

  @override
  bool get isInitialized => _imagePicker != null;

  @override
  Future<XFile?> pickImage({
    required ImageSource source,
    double? maxWidth,
    double? maxHeight,
    int? imageQuality,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
    bool requestFullMetadata = true,
  }) async {
    requireToBeInitialized(
        errorMessage: 'To pick image, please initlize the service first');
    image_picker_package.ImageSource;
    final xfile = await _imagePicker?.pickImage(
      source: source.toImageSourceOfImagePickerPackage(),
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
      preferredCameraDevice:
          preferredCameraDevice.toCameraDeviceOfImagePickerPackage(),
      requestFullMetadata: requestFullMetadata,
    );
    if (xfile == null) return null;
    return xfile;
  }
}

// I want to use depened on third party packages as much as possible.

extension ImagePickerPackageImageSource on ImageSource {
  image_picker_package.ImageSource toImageSourceOfImagePickerPackage() {
    switch (this) {
      case ImageSource.camera:
        return image_picker_package.ImageSource.camera;
      case ImageSource.gallery:
        return image_picker_package.ImageSource.gallery;
    }
  }
}

extension ImagePickerPackageCameraDevice on CameraDevice {
  image_picker_package.CameraDevice toCameraDeviceOfImagePickerPackage() {
    switch (this) {
      case CameraDevice.rear:
        return image_picker_package.CameraDevice.rear;
      case CameraDevice.front:
        return image_picker_package.CameraDevice.front;
    }
  }
}
