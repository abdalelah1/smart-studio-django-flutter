import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_studio/classes/photo.dart';

import '../../http/http.dart';

class FullScreenImagePage extends StatefulWidget {
  FullScreenImagePage({Key? key, required this.photo}) : super(key: key);

  final Photo photo;

  @override
  _FullScreenImagePageState createState() => _FullScreenImagePageState();
}

class _FullScreenImagePageState extends State<FullScreenImagePage> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile;

  bool _showEditIcons = false;
  bool _showCropAndFilterIcons = false;
  bool _isCropping = false;

  Future<void> _confirmDeleteImage() async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        await deletePhoto(widget.photo.id);
        // Image deleted successfully, navigate back and pass the photo ID as a result
        Navigator.pop(context, widget.photo.id);
      } catch (e) {
        // Error occurred while deleting image, handle the error
        print('Failed to delete image: $e');
      }
    }
  }

  Future<void> _cropImage1() async {
    if (_pickedFile != null) {
      print('from crop');
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: _pickedFile!.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 100,
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
          ]);
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  void _toggleEditIcons() {
    setState(() {
      _showEditIcons = !_showEditIcons;
      _showCropAndFilterIcons = false;
    });
  }

  void _toggleCropAndFilterIcons() {
    setState(() {
      _showCropAndFilterIcons = !_showCropAndFilterIcons;
      _showEditIcons = false;
    });
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      setState(() {
        _isCropping = true;
      });

      // Perform crop operation here

      setState(() {
        _isCropping = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = XFile(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Isinfavorite();
  }

  bool isin = false;
  void Isinfavorite() async {
    final inFavorites = await checkIfInFavorites(widget.photo.id);
    print(inFavorites);
    print(widget.photo.id);

    setState(() {
      isin = inFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("isin" + isin.toString());

    return WillPopScope(
      onWillPop: () async {
        if (_isCropping) {
          return false; // Prevent back navigation during cropping
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleEditIcons,
          child: Stack(
            children: [
              Center(
                child: Image.memory(
                  widget.photo.imageBytes,
                  fit: BoxFit.contain,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  color: _showEditIcons ? Colors.white : Colors.transparent,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: Visibility(
                  visible: _showEditIcons,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          int id = widget.photo.id;
                          print("id " + id.toString());
                          if (isin) {
                            
                            removeFromFavorites(id);
                            setState(() {
                              isin = false;
                            });
                          } else {
                            addToFavorites(id);
                            setState(() {
                              isin = true;
                            });
                          }
                        },
                        icon: isin
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border),
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.white,
                        onPressed: _confirmDeleteImage,
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.white,
                        onPressed: _toggleCropAndFilterIcons,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Visibility(
                  visible: _showCropAndFilterIcons,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.crop),
                        color: Colors.white,
                        onPressed: _cropImage1,
                      ),
                      IconButton(
                        icon: Icon(Icons.color_lens),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Perform save operation
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
