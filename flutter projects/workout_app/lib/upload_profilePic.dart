import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import 'BottomNagivationBar.dart';

class UploadProfilePic extends StatefulWidget {
  const UploadProfilePic({Key? key}) : super(key: key);

  @override
  _UploadProfilePicState createState() => _UploadProfilePicState();
}

class _UploadProfilePicState extends State<UploadProfilePic> {
  File? profilePic;

  void saveProfilePic() async {
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      File convertedFile = File(selectedImage.path);
      setState(() {
        profilePic = convertedFile;
      });
      _showSnackbar('Profile Image Updated');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Nav()),
      );
    } else {
      print("no image selected");
    }

    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("ProfilePictures_folder")
        .child(Uuid().v1())
        .putFile(profilePic!);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    User? user = FirebaseAuth.instance.currentUser;
    String? uid = user?.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'downloadUrl': downloadUrl,
    });
    await user?.updatePhotoURL(downloadUrl);
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
        title: Text('Upload Profile Picture'),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveProfilePic
              // Implement the logic to upload the profile picture
              // You can use a backend service for this purpose
              ,
              child: Text('Upload Profile Picture'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Nav()));
                // Implement the logic to skip this step
                // For example, you can navigate to the next page
              },
              child: Text('Skip'),
            ),
          ],
        ),
      ),
    );
  }
}
