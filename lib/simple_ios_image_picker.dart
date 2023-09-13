import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class SimpleIosImagePicker {
  final methodChannel = const MethodChannel('simple_ios_image_picker');

  /// [limit] is the maximum number of images that can be selected. If it is 0, there is no limit.
  ///
  /// [compressionQuality] is the quality of the image compression. The value is between 0.0 and 1.0.
  Future<List<XFile>?> pickImages({
    int limit = 0,
    double compressionQuality = 1.0,
    int? minWidth,
    int? minHeight,
  }) async {
    final List<dynamic>? resultList =
        await methodChannel.invokeMethod('pickImage', {
      "limit": limit,
      'compressionQuality': compressionQuality,
    });

    if (resultList == null) {
      return null;
    }
    final uint8ListList = await _nativeResultToResizeUint8ListList(
        resultList, minWidth, minHeight);
    final xFileList = await _uint8ListListToXFileList(uint8ListList);
    return xFileList;
  }

  /// convert native result to Uint8ListList
  Future<List<Uint8List>> _nativeResultToResizeUint8ListList(
      List<dynamic> nativeResult, int? minWidth, int? minHeight) async {
    var uint8ListList = <Uint8List>[];

    for (var item in nativeResult) {
      if (minWidth == null || minHeight == null) {
        final resizedUint8List = await _resizeUint8List(
          item as Uint8List,
          minWidth,
          minHeight,
        );
        uint8ListList.add(resizedUint8List);
      } else {
        uint8ListList.add(item as Uint8List);
      }
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

  Future<Uint8List> _resizeUint8List(
    Uint8List uint8list,
    int? minWidth,
    int? minHeight,
  ) async {
    final compressList = await FlutterImageCompress.compressWithList(
      uint8list,
      minWidth: minWidth ?? 1920,
      minHeight: minHeight ?? 1080,
    );
    return compressList;
  }
}
