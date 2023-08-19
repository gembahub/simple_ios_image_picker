import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'simple_ios_image_picker_method_channel.dart';

abstract class SimpleIosImagePickerPlatform extends PlatformInterface {
  /// Constructs a SimpleIosImagePickerPlatform.
  SimpleIosImagePickerPlatform() : super(token: _token);

  static final Object _token = Object();

  static SimpleIosImagePickerPlatform _instance = MethodChannelSimpleIosImagePicker();

  /// The default instance of [SimpleIosImagePickerPlatform] to use.
  ///
  /// Defaults to [MethodChannelSimpleIosImagePicker].
  static SimpleIosImagePickerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SimpleIosImagePickerPlatform] when
  /// they register themselves.
  static set instance(SimpleIosImagePickerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
