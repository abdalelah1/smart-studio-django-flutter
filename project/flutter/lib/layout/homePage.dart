import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';

import '../http/http.dart';
import '../modules/albumPage/albumPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  void _openImagePicker(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
        source: ImageSource
            .gallery); // You can change the source to ImageSource.camera to open the camera instead of the gallery

    if (pickedFile != null) {
      // Print the path of the selected image
      print(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('smart studio'),
      ),
      body: AlbumPage(),


      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendImageToDjango();
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
