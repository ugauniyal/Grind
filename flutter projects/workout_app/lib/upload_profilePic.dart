import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'BottomNagivationBar.dart';

class UploadProfilePic extends StatefulWidget {
  const UploadProfilePic({super.key});

  @override
  _UploadProfilePicState createState() => _UploadProfilePicState();
}

class _UploadProfilePicState extends State<UploadProfilePic> {
  File? profilePic;

  final picker = ImagePicker();

  void showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 5.2,
            margin: const EdgeInsets.only(top: 8.0),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: InkWell(
                    child: const Column(
                      children: [
                        Icon(
                          Icons.image,
                          size: 60.0,
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          "Gallery",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        )
                      ],
                    ),
                    onTap: () async {
                      await _imgFromGallery();
                    },
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: const SizedBox(
                      child: Column(
                        children: [
                          Icon(
                            Icons.camera_alt,
                            size: 60.0,
                          ),
                          SizedBox(height: 12.0),
                          Text(
                            "Camera",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      await _imgFromCamera();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _imgFromGallery() async {
    Navigator.pop(context);

    PermissionStatus galleryStatus = await Permission.storage.request();

    if (galleryStatus == PermissionStatus.granted) {
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        _cropImage(File(pickedFile.path));
      }
    }
    if (galleryStatus == PermissionStatus.denied) {
      _showSnackbar('Gallery permission is required to pick a photo.');
      return;
    }
    if (galleryStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _imgFromCamera() async {
    Navigator.pop(context);

    PermissionStatus cameraStatus = await Permission.camera.request();

    if (cameraStatus == PermissionStatus.granted) {
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );

      if (pickedFile != null) {
        _cropImage(File(pickedFile.path));
      }
    }
    if (cameraStatus == PermissionStatus.denied) {
      _showSnackbar('Camera permission is required to upload a photo');
      return;
    }
    if (cameraStatus == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    }
  }

  void saveProfilePic(final croppedFile) async {
    if (croppedFile != null) {
      File convertedFile = File(croppedFile.path);
      setState(() {
        profilePic = convertedFile;
      });
      _showSnackbar('Profile Image Updated');

      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child("ProfilePictures_folder")
          .child(const Uuid().v1())
          .putFile(profilePic!);

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      User? user = FirebaseAuth.instance.currentUser;
      String? uid = user?.uid;
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'downloadUrl': downloadUrl,
      });
      await user?.updatePhotoURL(downloadUrl);

      // Navigate to the homepage after the image is uploaded and saved
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Nav()),
      );
    } else {
      print("no image selected");
    }
  }

  void _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imgFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Image Cropper",
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: "Image Cropper",
        ),
      ],
    );

    if (croppedFile != null) {
      imageCache.clear();
      saveProfilePic(croppedFile);
    } else {
      // Handle the case when the user cancels cropping
      _showSnackbar('Image cropping canceled');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Profile Picture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                // Function to pick an image from the gallery
                // You can use plugins like image_picker for this purpose
              },
              child: CircleAvatar(
                radius: 80,
                backgroundImage:
                    (profilePic != null) ? FileImage(profilePic!) : null,
                backgroundColor: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showImagePicker(context);
              },
              child: const Text('Upload Profile Picture'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const Nav()));
                // Implement the logic to skip this step
                // For example, you can navigate to the next page
              },
              child: const Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }
}
