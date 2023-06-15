import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../classes/photo.dart';
import '../Full_screen/fullScreenImage.dart';

class ImageGridPage extends StatelessWidget {
  ImageGridPage({Key? key, required this.photos}) : super(key: key);

  final List<Photo> photos;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Grid'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: photos.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (context, index) {
          final photo = photos[index];
          return GestureDetector(
            onTap: () {
              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FullScreenImagePage(photo: photo),
                ),
              );
            },
            child: Hero(
              tag: 'image_$index',
              child: Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.memory(
                    photo.imageBytes,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
