import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_app/AuthCheck.dart';
import 'package:workout_app/BottomNagivationBar.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;

  late TextEditingController nameController;
  var usernameController = TextEditingController(text: "");
  late TextEditingController bioController;
  var passwordController = TextEditingController();
  var CpasswordController = TextEditingController();
  File? profilePic;
  File? viewPhoto;

  bool showCurrentPassword = false;
  bool showNewPassword = false;
  bool showConfirmPassword = false;

  bool isNameChanged = false;
  bool isUsernameChanged = false;
  bool isBioChanged = false;
  late FocusNode nameFocusNode;
  late FocusNode usernameFocusNode;
  late FocusNode bioFocusNode;

  bool isBioLoaded = false;
  bool isUsernameUnique = true;
  String? viewPhotoUrl;

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> updateName() async {
    String name = nameController.text.trim();

    if (name != "") {
      setState(() {
        isNameChanged = false; // Reset the flag after updating the name
        _showSnackbar('Name Updated');
      });
      nameFocusNode.unfocus();

      String? uid = user?.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
      });
    }
  }

  Future<void> updateBio() async {
    String bio = bioController.text.trim();

    if (bio != "") {
      setState(() {
        isBioChanged = false; // Reset the flag after updating the name
        _showSnackbar('Bio Updated');
      });
      bioFocusNode.unfocus();

      String? uid = user?.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'bio': bio,
      });
    }
  }

  Future<void> updateUsername() async {
    String newUsername = usernameController.text.trim();

    if (newUsername.isNotEmpty) {
      // Check if the new username is unique
      bool isUnique = await checkUsernameUniqueness(newUsername);

      if (isUnique) {
        setState(() {
          isUsernameChanged = false;
          isUsernameUnique = true;
          _showSnackbar('Username Updated');
        });

        // Update the display name in Firebase Authentication
        user?.updateDisplayName(newUsername);
      } else {
        setState(() {
          isUsernameUnique = false;
        });
      }
    } else {
      // Handle the case where the new username is empty
      _showSnackbar('Username cannot be empty');
    }

    usernameFocusNode.unfocus();
  }

  Future<bool> checkUsernameUniqueness(String newUsername) async {
    try {
      // Query Firestore to check if the username already exists
      newUsername = newUsername.trim();
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: newUsername)
              .get();

      // If the query returns no documents, the username is unique
      return querySnapshot.docs.isEmpty;
    } catch (error) {
      // Handle the error (e.g., log it or show a generic error message)
      print('Error checking username uniqueness: $error');
      return false;
    }
  }

  void updateProfilePic() async {
    String? uid = user?.uid;
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      File convertedFile = File(selectedImage.path);
      setState(() {
        profilePic = convertedFile;
      });
      _showSnackbar('Profile Image Updated');
    } else {
      print("No image selected");
      return;
    }

    // Upload the new profile picture to Firebase Storage
    UploadTask uploadTask = FirebaseStorage.instance
        .ref()
        .child("ProfilePictures_folder")
        .child(Uuid().v1())
        .putFile(profilePic!);

    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    // Update the user's photoURL in Firebase Authentication
    try {
      await user?.updatePhotoURL(downloadUrl);
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'downloadUrl': downloadUrl,
      });

      // Ensure the user information is refreshed
      await user?.reload();

      // Access the refreshed user information
      User? updatedUser = FirebaseAuth.instance.currentUser;

      // Update the user variable to trigger a rebuild
      setState(() {
        user = updatedUser;
      });

      // Perform any additional update logic here

      _showSnackbar('profile Picture Uploaded');
    } catch (error) {
      _showSnackbar('Error updating profile picture');
    }
  }

  void saveViewPhoto() async {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user?.uid ?? '';
    XFile? selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (selectedImage != null) {
      File convertedFile = File(selectedImage.path);

      try {
        // Image is being uploaded
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child("ViewerPictures_folder")
            .child(Uuid().v1())
            .putFile(convertedFile);

        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl1 = await taskSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'downloadUrl1': downloadUrl1,
        });

        await user?.reload();

        _showSnackbar('View Image Updated');

        // Wait for the setState to complete before navigating
        setState(() {});

        print("View Photo URL: $viewPhotoUrl");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditProfilePage()),
        );
      } catch (error) {
        print("Error uploading image: $error");
        _showSnackbar('Error uploading image');
      }
    } else {
      _showSnackbar('No image selected');
    }
  }

  Future<void> getDownloadUrl() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user?.uid)
          .get();
      String updatedDownloadUrl = snapshot.data()?['downloadUrl1'] ?? "";

      setState(() {
        viewPhotoUrl = updatedDownloadUrl;
      });
    } catch (error) {
      print("Error fetching download URL: $error");
      // Handle the error, e.g., show a default image or a placeholder
      setState(() {
        viewPhotoUrl =
            'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg';
      });
    }
  }

  void initState() {
    super.initState();
    getDownloadUrl();

    nameController = TextEditingController();
    bioController = TextEditingController();
    fetchNameFromFirestore();
    fetchBioFromFirestore();
    usernameController = TextEditingController(text: user?.displayName ?? "");
    nameFocusNode = FocusNode();
    usernameFocusNode = FocusNode();
    bioFocusNode = FocusNode();
  }

  Future<void> fetchNameFromFirestore() async {
    String? uid = user?.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    String name = snapshot.data()?['name'] ?? "";

    setState(() {
      nameController.text = name;
    });
  }

  Future<void> fetchBioFromFirestore() async {
    String? uid = user?.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    String bio = snapshot.data()?['bio'] ?? "";
    setState(() {
      bioController = TextEditingController(text: bio);
    });
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    usernameFocusNode.dispose();
    bioFocusNode.dispose();
    super.dispose();
  }

  void saveChanges() async {
    String newPassword = passwordController.text.trim();
    String ConfirmPassword = CpasswordController.text.trim();
    if (newPassword == "" || ConfirmPassword == "") {
      _showSnackbar('Please enter New Password details');
    } else if (newPassword != ConfirmPassword) {
      _showSnackbar('Password does not match');
    } else {
      try {
        if (user != null) {
          await user?.updatePassword(newPassword);
          _showSnackbar('Changes Done');
        }
      } on FirebaseAuthException catch (ex) {
        _showSnackbar(ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Nav())),
        ),
        elevation: 0,
        backgroundColor: Colors.white54,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Edit Your Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          child: ClipOval(
                            child: Image.network(
                              user?.photoURL ??
                                  'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: updateProfilePic,
                          child: Text(
                            "Edit Profile Picture",
                            style: TextStyle(fontSize: 14, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          child: ClipOval(
                            child: Image.network(
                              viewPhotoUrl ??
                                  'https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: saveViewPhoto,
                          child: Text(
                            "Edit Grind Picture",
                            style: TextStyle(fontSize: 14, color: Colors.blue),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Expanded(
                    child: TextFormField(
                      cursorColor: Colors.black,
                      controller: nameController,
                      onChanged: (value) {
                        setState(() {
                          isNameChanged = true;
                        });
                      },
                      focusNode: nameFocusNode,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusColor: Colors.black,
                        suffixIcon: isNameChanged
                            ? IconButton(
                                icon: Icon(Icons.check),
                                onPressed: updateName,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    controller: usernameController,
                    onChanged: (value) async {
                      bool isUnique = await checkUsernameUniqueness(value);
                      setState(() {
                        isUsernameChanged = true;
                        isUsernameUnique = isUnique;
                      });
                    },
                    focusNode: usernameFocusNode,
                    decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusColor: Colors.black,
                      suffixIcon: isUsernameChanged
                          ? IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () => updateUsername(),
                            )
                          : null,
                      suffixText: isUsernameChanged
                          ? isUsernameUnique
                              ? 'Available'
                              : 'Not Available'
                          : '',
                      suffixStyle: TextStyle(
                          color: isUsernameChanged
                              ? isUsernameUnique
                                  ? Colors.green
                                  : Colors.red
                              : Colors.transparent),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    cursorColor: Colors.black,
                    controller: bioController,
                    onChanged: (value) {
                      setState(() {
                        isBioChanged = true;
                      });
                    },
                    focusNode: bioFocusNode,
                    maxLength: 50,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    decoration: InputDecoration(
                      labelText: "Bio",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusColor: Colors.black,
                      suffixIcon: isBioChanged
                          ? IconButton(
                              icon: Icon(Icons.check),
                              onPressed: updateBio,
                            )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () async {
                      await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AuthCheck()));
                      // Additional code to execute after navigating (if needed)
                    },
                    child: const Text(
                      'Change Password?',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
