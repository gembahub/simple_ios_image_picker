import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cross_file/cross_file.dart';

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
  List<XFile>? pickedFileList;

  Future<void> pickSingleImage(double compressionQuality) async {
    final fileList = await _simpleIosImagePickerPlugin.pickImages(
        compressionQuality: compressionQuality);
    setState(() {
      pickedFileList = fileList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('pickedFile: $pickedFileList'),
            ),
            ElevatedButton(
              onPressed: () => pickSingleImage(1),
              child: const Text('pick image'),
            )
          ],
        ),
      ),
    );
  }
}
