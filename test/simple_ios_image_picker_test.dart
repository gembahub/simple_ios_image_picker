import 'package:flutter_test/flutter_test.dart';
import 'package:simple_ios_image_picker/simple_ios_image_picker.dart';
import 'package:simple_ios_image_picker/simple_ios_image_picker_platform_interface.dart';
import 'package:simple_ios_image_picker/simple_ios_image_picker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSimpleIosImagePickerPlatform
    with MockPlatformInterfaceMixin
    implements SimpleIosImagePickerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SimpleIosImagePickerPlatform initialPlatform = SimpleIosImagePickerPlatform.instance;

  test('$MethodChannelSimpleIosImagePicker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSimpleIosImagePicker>());
  });

  test('getPlatformVersion', () async {
    SimpleIosImagePicker simpleIosImagePickerPlugin = SimpleIosImagePicker();
    MockSimpleIosImagePickerPlatform fakePlatform = MockSimpleIosImagePickerPlatform();
    SimpleIosImagePickerPlatform.instance = fakePlatform;

    expect(await simpleIosImagePickerPlugin.getPlatformVersion(), '42');
  });
}
