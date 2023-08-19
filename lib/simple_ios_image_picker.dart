import 'package:flutter/services.dart';

class SimpleIosImagePicker {
  final methodChannel = const MethodChannel('simple_ios_image_picker');

  Future<List<Uint8List>?> pickImages({
    int limit = 10,
    double compressionQuality = 1.0,
  }) async {
    final List<dynamic>? resultList =
        await methodChannel.invokeMethod('pickImage', {
      "limit": limit,
      'compressionQuality': compressionQuality,
    });
    if (resultList != null) {
      return resultList.map((item) => item as Uint8List).toList();
    }
    return null;
  }

  Future<void> _uint8ListToXFile() async {
    //
  }
}
