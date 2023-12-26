import 'package:cross_file/cross_file.dart';
import 'package:flutter/services.dart';

class SimpleIosImagePicker {
  final methodChannel = const MethodChannel('simple_ios_image_picker');

  /// [limit] is the maximum number of images that can be selected. If it is 0, there is no limit.
  ///
  /// [compressionQuality] is the quality of the image compression. The value is between 0.0 and 1.0.
  ///
  /// [width] and [height] are the width and height of the image.
  Future<List<XFile>?> pickImages({
    int limit = 0,
    int? maxWidth,
    int? maxHeight,
    double compressionQuality = 1.0,
  }) async {
    final List<dynamic>? resultList =
        await methodChannel.invokeMethod('pickImage', {
      "limit": limit,
      'compressionQuality': compressionQuality,
      'maxWidth': maxWidth,
      'maxHeight': maxHeight,
    });

    if (resultList == null) {
      return null;
    }
    final uint8ListList = _nativeResultToUint8ListList(resultList);
    final xFileList = await _uint8ListListToXFileList(uint8ListList);
    return xFileList;
  }

  Future<List<Uint8List>?> pickImagesAsByData({
    int limit = 0,
    int? maxHeight,
    int? maxWidth,
    double compressionQuality = 1.0,
  }) async {
    final List<dynamic>? resultList =
        await methodChannel.invokeMethod('pickImage', {
      "limit": limit,
      'compressionQuality': compressionQuality,
      'maxHeight': maxHeight,
      'maxWidth': maxWidth,
    });

    if (resultList == null) {
      return null;
    }
    final uint8ListList = _nativeResultToUint8ListList(resultList);
    return uint8ListList;
  }

  /// convert native result to Uint8ListList
  List<Uint8List> _nativeResultToUint8ListList(List<dynamic> nativeResult) {
    var uint8ListList = <Uint8List>[];

    for (var item in nativeResult) {
      uint8ListList.add(item as Uint8List);
    }

    return uint8ListList;
  }

  /// convert Uint8List to XFile
  Future<XFile> _uint8ListToXFile(Uint8List bytes) async =>
      XFile.fromData(bytes);

  /// convert multiple Uint8List to XFile
  Future<List<XFile>> _uint8ListListToXFileList(
      List<Uint8List> uint8ListList) async {
    var xFileList = <XFile>[];

    for (var uint8List in uint8ListList) {
      xFileList.add(await _uint8ListToXFile(uint8List));
    }

    return xFileList;
  }
}
