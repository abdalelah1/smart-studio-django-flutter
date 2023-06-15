import 'package:flutter/material.dart';
import 'package:smart_studio/classes/photo.dart';

import '../../http/http.dart';
import '../imageGrid/imageGrid.dart';

class AlbumPage extends StatelessWidget {
  AlbumPage({Key? key}) : super(key: key);

  final List<String> albums = [
    'Person',
    'Animals',
    'Food',
    'Thing',
    'Duplicated Photos',
    'All Photos'
  ];

  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            if (albums[index] == 'All Photos') {
              List<Photo> photos = await fetchAllPhotos();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageGridPage(photos: photos),
                ),
              );
            } else if (albums[index] == 'Duplicated Photos') {
              List<Photo> photos = await fetchDuplicatePhotos();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageGridPage(photos: photos),
                ),
              );
            } else {
              List<Photo> photos =
                  await fetchPhotosByCategory(albums[index].toLowerCase());
              print('category is  : ' + albums[index]);
              print(photos.length);
              // Navigate to the details page for the selected album
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageGridPage(
                          photos: photos,
                        )),
              );
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2.0),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio:
                      16 / 9, // Adjust the aspect ratio as per your requirement
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            NetworkImage('https://i.redd.it/w3kr4m2fi3111.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  color: Colors.black.withOpacity(0.7),
                  child: Center(
                    child: Text(
                      albums[index],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
