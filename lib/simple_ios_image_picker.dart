import 'package:flutter/services.dart';

import 'simple_ios_image_picker_platform_interface.dart';

class SimpleIosImagePicker {
  static const platform = MethodChannel('jp.artsn/ios');

  Future<String?> getPlatformVersion() {
    return SimpleIosImagePickerPlatform.instance.getPlatformVersion();
  }
}
