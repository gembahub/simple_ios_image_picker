import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'simple_ios_image_picker_platform_interface.dart';

/// An implementation of [SimpleIosImagePickerPlatform] that uses method channels.
class MethodChannelSimpleIosImagePicker extends SimpleIosImagePickerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('simple_ios_image_picker');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
