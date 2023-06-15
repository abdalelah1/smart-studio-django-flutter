import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../classes/photo.dart';

Future<bool> checkConnection() async {
  try {
    final response =
        await http.get(Uri.parse('http://192.168.1.12:8000/api/endpoint'));
    if (response.statusCode == 200) {
      print('Connection successful');
      return true;
    } else {
      print('Connection failed');
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}
Future<void> sendImageToDjango() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile != null) {
    List<int> imageBytes = await pickedFile.readAsBytes();

    // Create a multipart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.12:8000/api/upload'),
    );

    // Attach the file to the request
    request.files.add(http.MultipartFile(
      'image',
      http.ByteStream.fromBytes(imageBytes),
      imageBytes.length,
      filename: pickedFile.path.split('/').last,
      contentType: MediaType('image', 'jpeg'), // Adjust the content type according to your image format
    ));
    if (pickedFile != null) {
  File imageFile = File(pickedFile.path);
  bool fileExists = await imageFile.exists();
  
  if (fileExists) {
    print('File exists at path: ${imageFile.path}');
  } else {
    print('File does not exist at path: ${imageFile.path}');
  }
}
    // Send the request
    var response = await request.send();
    if (response.statusCode == 200) {
      print('Image sent to Django successfully');
    } else {
      print('Failed to send image to Django ${response.statusCode}');
    }
  }
}



Future<List<Photo>> fetchAllPhotos() async {
  final baseUrl = 'http://192.168.1.12:8000'; // Replace with your base URL
  final response = await http.get(Uri.parse('$baseUrl/api/photos'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    final List<Photo> photos = [];

    for (var item in jsonData) {
      final imageUrl = '$baseUrl${item['image']}';
      final imageResponse = await http.get(Uri.parse(imageUrl));
      if (imageResponse.statusCode == 200) {
        print('success to fitch${item['id']}');
        final photo = Photo(
          id: item['id'],
          title: item['title'],
          description: item['description'],
          imageBytes: imageResponse.bodyBytes,
        );
        photos.add(photo);
      } else {
        // Handle error
        print(
            'Failed to fetch image for photo ${item['id']}: ${imageResponse.statusCode}');
      }
    }

    return photos;
  } else {
    // Handle error
    print('Failed to fetch all photos: ${response.statusCode}');
    return [];
  }
}
Future<List<Photo>> fetchPhotosByCategory(String category) async {
  final baseUrl = 'http://192.168.1.12:8000'; // Replace with your Django server URL
  final response = await http.get(Uri.parse('$baseUrl/api/category/?category=$category'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    final List<Photo> photos = [];

    for (var item in jsonData) {
      final imageUrl = '$baseUrl${item['image']}';
      final imageResponse = await http.get(Uri.parse(imageUrl));
      if (imageResponse.statusCode == 200) {
        final photo = Photo(
          id: item['id'],
          imageBytes: imageResponse.bodyBytes,
          title: item['title'],
          description: item['description'],
        );
        photos.add(photo);
      } else {
        // Handle error
        print('Failed to fetch image for photo ${item['id']}: ${imageResponse.statusCode}');
      }
    }

    return photos;
  } else {
    throw Exception('Failed to fetch photos by category: ${response.statusCode}');
  }
}
Future<List<Photo>> fetchDuplicatePhotos() async {
  final baseUrl = 'http://192.168.1.12:8000'; // Replace with your Django server URL
  final response = await http.get(Uri.parse('$baseUrl/api/duplicated'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    final List<Photo> photos = [];

    for (var item in jsonData) {
      final imageUrl = '$baseUrl${item['image']}';
      final imageResponse = await http.get(Uri.parse(imageUrl));
      if (imageResponse.statusCode == 200) {
        final photo = Photo(
          id: item['id'],
          imageBytes: imageResponse.bodyBytes,
          title: item['title'],
          description: item['description'],
        );
        photos.add(photo);
      } else {
        // Handle error
        print('Failed to fetch image for photo ${item['id']}: ${imageResponse.statusCode}');
      }
    }

    return photos;
  } else {
    throw Exception('Failed to fetch duplicate photos: ${response.statusCode}');
  }
}

Future<void> deletePhoto(int photoId) async {
    final baseUrl = 'http://192.168.1.12:8000'; // Replace with your Django server URL
    final url = Uri.parse('$baseUrl/api/photos/$photoId/delete/');
    
    final response = await http.delete(url);
    
    if (response.statusCode == 200) {
      // Image deleted successfully
      print('Image deleted successfully.');
    } else {
      // Error occurred while deleting image
      print('Failed to delete image: ${response.statusCode}');
    }
  }
  Future<void> sendCroppedImageToDjango(File croppedImage) async {
  List<int> imageBytes = await croppedImage.readAsBytes();

  // Create a multipart request
  var request = http.MultipartRequest(
    'POST',
    Uri.parse('http://192.168.1.12:8000/api/upload'),
  );

  // Attach the file to the request
  request.files.add(http.MultipartFile(
    'image',
    http.ByteStream.fromBytes(imageBytes),
    imageBytes.length,
    filename: croppedImage.path.split('/').last,
    contentType: MediaType('image', 'jpeg'), // Adjust the content type according to your image format
  ));

  // Send the request
  var response = await request.send();
  if (response.statusCode == 200) {
    print('Cropped image sent to Django successfully');
  } else {
    print('Failed to send cropped image to Django ${response.statusCode}');
  }
}

Future<void> addToFavorites(int photoId) async {
  final baseUrl = 'http://192.168.1.12:8000'; // Replace with your Django server URL
  final url = Uri.parse('$baseUrl/api/favorite/$photoId');

  final response = await http.post(url);
  if (response.statusCode == 200) {
    print('Photo added to favorites successfully.');
  } else {
    print('Failed to add photo to favorites: ${response.statusCode}');
  }
}
Future<bool> checkIfInFavorites(int photoId) async {
  final baseUrl = 'http://192.168.1.12:8000'; // Replace with your Django server URL
  final url = Uri.parse('$baseUrl/api/checkFavorite/$photoId');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final responseData = json.decode(response.body);
    final bool isInFavorites = responseData['is_favorite'];
    return isInFavorites;
  } else {
    throw Exception('Failed to check if photo is in favorites: ${response.statusCode}');
  }
}

Future<void> removeFromFavorites(int photoId) async {
  final baseUrl = 'http://192.168.1.12:8000'; // Replace with your Django server URL
  final url = Uri.parse('$baseUrl/api/removeFromFavorite/$photoId');

  final response = await http.delete(url);
  if (response.statusCode == 200) {
    // Photo removed from favorites successfully
    print('Photo removed from favorites.');
  } else if (response.statusCode == 404) {
    // Photo not found in favorites
    print('Photo not found in favorites.');
  } else {
    // Error occurred while removing photo from favorites
    print('Failed to remove photo from favorites: ${response.statusCode}');
  }
}