import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:simple_ios_image_picker/simple_ios_image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _simpleIosImagePickerPlugin = SimpleIosImagePicker();
  List<Uint8List>? pickedFileList;

  Future<void> pickSingleImage(
    double compressionQuality,
    int width,
    int height,
  ) async {
    final fileList = await _simpleIosImagePickerPlugin.pickImagesAsByData(
      compressionQuality: compressionQuality,
      maxWidth: width,
      maxHeight: height,
    );
    setState(() {
      pickedFileList = fileList;
    });
  }

  Widget images() {
    final imageList = pickedFileList;
    if (imageList == null) return const SizedBox.shrink();

    if (imageList.isNotEmpty) {
      print('imageBytes: ${imageList.first.lengthInBytes}');
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: imageList
              .map(
                (image) => Image.memory(
                  image,
                  width: 200,
                  height: 200,
                ),
              )
              .toList(),
        ),
      );
    } else {
      return const Text('No image picked.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Welcome'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: images()),
            const SizedBox(
              height: 40,
            ),
            ElevatedButton(
              onPressed: () => pickSingleImage(0.1, 100, 200),
              child: const Text('pick image'),
            )
          ],
        ),
      ),
    );
  }
}
